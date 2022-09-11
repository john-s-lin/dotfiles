#!/usr/bin/env bash

# Install Homebrew
echo "Checking for Homebrew..."
if test ! $(which brew); then
    echo "Install Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed!"
else
    echo "`brew --version` already installed."
fi

# Install git
echo "Checking for git..."
if test ! $(which git); then
    echo "Install git..."
    brew install git
    echo "git installed!"
else
    echo "`git --version` already installed."
fi

# TODO


# Disable Microsoft AutoUpdate
launchctl disable gui/$(id -u)/com.microsoft.update.agent

