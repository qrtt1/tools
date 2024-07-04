#!/bin/bash

usage() {
    echo "Usage: $0 [OPTIONS] COMMAND [ARGS...]"
    echo
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo
    echo "Commands:"
    echo "  export        Export environment variables"
    echo
    echo "Examples:"
    echo "  $0 export"
    echo "  $0 ./gradlew build"
    echo "  $0 -h"
    echo
    echo "Configuration:"
    echo "  The script looks for the TM_CFG_PATH variable in the following order:"
    echo "    1. Environment variable TM_CFG_PATH"
    echo "    2. .tm_env file in the current directory"
    echo "    3. .tm_env file in the home directory"
    echo
    echo "  The .tm_env file should contain the TM_CFG_PATH variable in the format:"
    echo "    TM_CFG_PATH=gs://your-bucket/path/to/env-vars"
    echo
    echo "  The environment variables file should contain key-value pairs in the format:"
    echo "    KEY1=value1"
    echo "    KEY2=value2"
    echo
    echo "  The keys in the environment variables file can contain dots (.), which will be"
    echo "  replaced with underscores (_) when exported."
}

get_gcs_path() {
    if [ -n "$TM_CFG_PATH" ]; then
        echo "$TM_CFG_PATH"
    elif [ -f ".tm_env" ]; then
        grep -E "^TM_CFG_PATH=" .tm_env | cut -d '=' -f 2
    elif [ -f "$HOME/.tm_env" ]; then
        grep -E "^TM_CFG_PATH=" "$HOME/.tm_env" | cut -d '=' -f 2
    else
        echo "Error: TM_CFG_PATH not found in environment variable, .tm_env, or $HOME/.tm_env"
        exit 1
    fi
}

set_env_vars() {
    gcs_path=$(get_gcs_path)
    
    if ! command -v gsutil &> /dev/null; then
        echo "Error: gsutil is not installed or not found in PATH."
        exit 1
    fi
    
    env_vars=$(gsutil cat "$gcs_path" 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: Failed to read env vars from $gcs_path. The file may not exist or you may not have permission to access it."
        exit 1
    fi
    
    while IFS='=' read -r key value; do
        key=$(echo "$key" | tr '.' '_')
        eval export "$key='$value'"
    done <<< "$env_vars"
}

if [ $# -eq 0 ]; then
    usage
    exit 1
fi

case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
    export)
        set_env_vars
        export
        exit 0
        ;;
    *)
        if command -v "$1" >/dev/null 2>&1; then
            set_env_vars
            if [ "$(type -t "$1")" = "builtin" ]; then
                eval "$@"
            else
                exec "$@"
            fi
        else
            echo "Error: $1 is not a valid command."
            echo
            usage
            exit 1
        fi
        ;;
esac
