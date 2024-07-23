#!/usr/bin/env bash

parent_dir="$(dirname "$(pwd)")"

# Enable symlinks for .zshrc, .bashrc, .condarc
ln -sfn "${parent_dir}/.zshrc" "${HOME}/.zshrc"
ln -sfn "${parent_dir}/.bashrc" "${HOME}/.bashrc"
ln -sfn "${parent_dir}/.condarc" "${HOME}/.condarc"
ln -sfn "${parent_dir}/.bash_aliases" "${HOME}/.bash_aliases"

# Symlink config settings
ln -sfn "${parent_dir}/config/nvim" "${HOME}/.config/nvim"
ln -sfn "${parent_dir}/config/tmux" "${HOME}/.config/tmux"
ln -sfn "${parent_dir}/config/alacritty" "${HOME}/.config/alacritty"

# If bottom exists, symlink bottom.toml config
if command -v btm >/dev/null 2>&1; then
	ln -sfn "${parent_dir}/config/bottom" "${HOME}/.config/bottom"
fi

exit 0
