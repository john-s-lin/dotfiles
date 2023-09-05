#!/usr/bin/env bash

# Install oh-my-tmux
git clone https://github.com/gpakosz/.tmux.git "$HOME/.oh-my-tmux"
mkdir -p "$HOME/.config/tmux"

# Symlink oh-my-tmux config
ln -s "$HOME/.oh-my-tmux/.tmux.conf" "$HOME/.config/tmux/tmux.conf"

# Symlink .dotfiles/config/tmux.conf.local
ln -s "$HOME/.dotfiles/config/tmux.conf.local" "$HOME/.config/tmux/tmux.conf.local"

exit 0

