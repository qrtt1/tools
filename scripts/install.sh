#!/bin/bash

install_dir="${HOME}/.tm_scripts"
script_url="https://raw.githubusercontent.com/qrtt1/tools/main/scripts/tm_env.sh"

if [ -d "$install_dir" ]; then
    echo "Warning: $install_dir already exists. Overwriting..."
    rm -rf "$install_dir"
fi

mkdir -p "$install_dir"

curl -fsSL "$script_url" -o "${install_dir}/tm_env"

chmod +x "${install_dir}/tm_env"

if [ -f "${HOME}/.bashrc" ]; then
    echo "export PATH=\"\$PATH:${install_dir}\"" >> "${HOME}/.bashrc"
    echo "bashrc_found=1" >> "${install_dir}/.env"
else
    echo "bashrc_found=0" >> "${install_dir}/.env"
fi

if [ -f "${HOME}/.zshrc" ]; then
    echo "export PATH=\"\$PATH:${install_dir}\"" >> "${HOME}/.zshrc"
    echo "zshrc_found=1" >> "${install_dir}/.env"
else
    echo "zshrc_found=0" >> "${install_dir}/.env"
fi

echo "tm_env has been installed to ${install_dir}"

if [ -f "${install_dir}/.env" ]; then
    source "${install_dir}/.env"
    if [ "${bashrc_found}" = "1" ] || [ "${zshrc_found}" = "1" ]; then
        echo "Please restart your shell or run the following command to start using tm_env:"
        [ "${bashrc_found}" = "1" ] && echo "source ~/.bashrc"
        [ "${zshrc_found}" = "1" ] && echo "source ~/.zshrc"
    else
        echo "No .bashrc or .zshrc file found. Please add the following line to your shell configuration file:"
        echo "export PATH=\"\$PATH:${install_dir}\""
    fi
    rm "${install_dir}/.env"
fi
