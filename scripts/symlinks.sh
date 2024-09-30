#!/usr/bin/env bash

# Enable symlinks for .zshrc, .bashrc, .condarc
ln -sfn "${DOTFILES_ROOT}/.zshrc" "${HOME}/.zshrc"
ln -sfn "${DOTFILES_ROOT}/.bashrc" "${HOME}/.bashrc"
ln -sfn "${DOTFILES_ROOT}/.condarc" "${HOME}/.condarc"
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
