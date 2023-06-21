#!/usr/bin/env bash

# Install Xcode CLT
sudo xcode-select --install

# Install Homebrew
echo "Checking for Homebrew..."
if test ! "$(which brew)"; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed!"
else
    echo "$(brew --version) already installed."
fi

# Check brew doctor
brew doctor

# Install brew packages from Brewfile
brew bundle install -v --file="$(pwd)"/Brewfile

# Install oh-my-zsh
# TODO oh-my-zsh install messes up the rest of the script
# Figure out a way to install this in a separate terminal
# chmod u+x "$(pwd)"/scripts/zsh_setup.sh
# sh -c "$(pwd)"/scripts/zsh_setup.sh

# Install fzf autocompletion
# TODO figure out how to install fzf autocomplete
# $(brew --prefix)/opt/fzf/install

# Initialize miniconda
conda init "$(basename "${SHELL}")"

# Disable Microsoft AutoUpdate
launchctl disable gui/"$(id -u)"/com.microsoft.update.agent
