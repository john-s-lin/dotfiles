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
brew bundle install -d --file="$(pwd)"/Brewfile

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Initialize miniconda
conda init "$(basename "${SHELL}")"

# Disable Microsoft AutoUpdate
launchctl disable gui/"$(id -u)"/com.microsoft.update.agent
