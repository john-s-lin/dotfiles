#!/usr/bin/env bash

# Install oh-my-tmux
git clone https://github.com/gpakosz/.tmux.git "~/.oh-my-tmux"
mkdir -p "~/.config/tmux"

# Symlink oh-my-tmux config
ln -s "~/.oh-my-tmux/.tmux.conf" "~/.config/tmux/tmux.conf"

exit 0

