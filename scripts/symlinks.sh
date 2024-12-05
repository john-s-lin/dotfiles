#!/usr/bin/env bash

# Set DOTFILES_ROOT to the upper directory of the current scjipt if not already set
if [ -z "$DOTFILES_ROOT" ]; then
	DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
fi

# Enable symlinks for .zshrc, .bashrc, .condarc
ln -sfn "${DOTFILES_ROOT}/.zshrc" "${HOME}/.zshrc"
ln -sfn "${DOTFILES_ROOT}/.bashrc" "${HOME}/.bashrc"

if [ uname -s == "Darwin" ]; then
	ln -sfn "${DOTFILES_ROOT}/.condarc" "${HOME}/.condarc"
elif [ uname -s == "Linux" ]; then
	ln -sfn "${DOTFILES_ROOT}/.condarc.linux" "${HOME}/.condarc"
fi

ln -sfn "${DOTFILES_ROOT}/.bash_aliases" "${HOME}/.bash_aliases"
ln -sfn "${DOTFILES_ROOT}/.gitconfig" "${HOME}/.gitconfig"

# Symlink config settings
ln -sfn "${DOTFILES_ROOT}/config/nvim" "${HOME}/.config/nvim"
ln -sfn "${DOTFILES_ROOT}/config/tmux" "${HOME}/.config/tmux"
ln -sfn "${DOTFILES_ROOT}/config/alacritty" "${HOME}/.config/alacritty"
ln -sfn "${DOTFILES_ROOT}/config/starship" "${HOME}/.config/starship"

# If bottom exists, symlink bottom.toml config
if command -v btm >/dev/null 2>&1; then
	ln -sfn "${DOTFILES_ROOT}/config/bottom" "${HOME}/.config/bottom"
fi

exit 0
