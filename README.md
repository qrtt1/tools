# TM_ENV

TM_ENV is a convenient shell script that loads environment variables from a remote configuration file before executing a command.

## Installation

To install TM_ENV, run:

```
curl -fsSL https://raw.githubusercontent.com/qrtt1/tools/main/scripts/install.sh | bash
```

After installation, restart your shell or run `source ~/.bashrc` or `source ~/.zshrc`.

## Usage

```
tm_env [OPTIONS] COMMAND [ARGS...]
```

### Options
- `-h`, `--help`: Show help message and exit.

### Commands
- `export`: Export environment variables.

### Examples
```
tm_env export
tm_env ./gradlew build
tm_env -h
```

## Configuration

TM_ENV looks for `TM_CFG_PATH` in:
1. `TM_CFG_PATH` environment variable
2. `.tm_env` file in current directory
3. `.tm_env` file in home directory

`.tm_env` file format:
```
TM_CFG_PATH=gs://your-bucket/path/to/env-vars
```

Environment variables file format:
```
KEY1=value1
KEY2=value2
```

## License

TM_ENV is licensed under the [MIT License](LICENSE).
