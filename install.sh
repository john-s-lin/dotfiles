#!/usr/bin/env bash

# Install Homebrew
echo "Checking for Homebrew..."
if test ! $(which brew); then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Homebrew installed!"
else
    echo "`brew --version` already installed."
fi

# Install git
echo "Checking for git..."
if test ! $(which git); then
    echo "Installing git..."
    brew install git
    echo "git installed!"
else
    echo "`git --version` already installed."
fi

# Install coreutils for passion.zsh-theme
echo "Installing coreutils..."
brew install coreutils
echo "coreutils installed!"

# Install openjdk@17
echo "Installing openjdk@17..."
brew install openjdk@17
echo "openjdk@17 installed!"

# Install tree
echo "Installing tree..."
brew install tree
echo "tree installed!"

##########
# CASKS
##########

# Install Firefox
echo "Installing firefox..."
brew install --cask firefox
echo "firefox installed!"

# Install iTerm2
echo "Installing iterm2..."
brew install --cask iterm2
echo "iterm2 installed!"

# Install chrome
echo "Installing google-chrome..."
brew install --cask google-chrome
echo "google-chrome installed!"

# Install drive
echo "Installing google-drive..."
brew install --cask google-drive
echo "google-drive installed!"

# Install spotify
echo "Installing spotify..."
brew install --cask spotify
echo "spotify installed!"

# Install miniconda
echo "Installing miniconda..."
brew install --cask miniconda
echo "miniconda installed!"

# Install rectangle
echo "Installing rectangle..."
brew install --cask rectangle
echo "rectangle installed!"

# Install selfcontrol
echo "Installing selfcontrol..."
brew install --cask selfcontrol
echo "selfcontrol installed!"

# Install vlc
echo "Installing vlc..."
brew install --cask vlc
echo "vlc installed!"

# Install vscode
echo "Installing vscode..."
brew install --cask visual-studio-code
echo "vscode installed!"

# Install microsoft-office
echo "Installing office..."
brew install --cask microsoft-office
echo "office installed!"

# Install discord
echo "Installing discord..."
brew install --cask discord
echo "discord installed!"

# Initialize miniconda
conda init "$(basename "${SHELL}")"

# Disable Microsoft AutoUpdate
launchctl disable gui/$(id -u)/com.microsoft.update.agent
