#!/usr/bin/env bash

# Set DOTFILES_ROOT to the upper directory of the current script if not already set
if [ -z "$DOTFILES_ROOT" ]; then
	DOTFILES_ROOT="${HOME}/.dotfiles"
fi

# Enable symlinks for .zshrc, .bashrc
ln -sfn "${DOTFILES_ROOT}/.zshrc" "${HOME}/.zshrc"
ln -sfn "${DOTFILES_ROOT}/.bashrc" "${HOME}/.bashrc"

# Aliases
ln -sfn "${DOTFILES_ROOT}/.bash_aliases" "${HOME}/.bash_aliases"

# Gitconfig
ln -sfn "${DOTFILES_ROOT}/.gitconfig" "${HOME}/.gitconfig"

# Symlink config settings
mkdir -p "${HOME}/.config"

ln -sfn "${DOTFILES_ROOT}/config/alacritty" "${HOME}/.config/alacritty"
ln -sfn "${DOTFILES_ROOT}/config/bat" "${HOME}/.config/bat"
ln -sfn "${DOTFILES_ROOT}/config/bottom" "${HOME}/.config/bottom"
ln -sfn "${DOTFILES_ROOT}/config/ghostty" "${HOME}/.config/ghostty"
ln -sfn "${DOTFILES_ROOT}/config/nvim" "${HOME}/.config/nvim"
ln -sfn "${DOTFILES_ROOT}/config/starship" "${HOME}/.config/starship"
ln -sfn "${DOTFILES_ROOT}/config/tmux" "${HOME}/.config/tmux"
ln -sfn "${DOTFILES_ROOT}/config/zed" "${HOME}/.config/zed"
ln -sfn "${DOTFILES_ROOT}/config/zellij" "${HOME}/.config/zellij"

exit 0
