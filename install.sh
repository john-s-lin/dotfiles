#!/usr/bin/env bash

# Ensure you are running as root
if [[ ${EUID} = 0 ]]; then
  echo "(1) Running as superuser already."
else
  # Reset user as superuser
  sudo -k
  if sudo true; then
    echo "(2) User changed to sudo."
  else
    echo "(3) Wrong password."
    exit 1
  fi
fi

# Install Xcode CLT
xcode-select --install

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

# Install fzf autocompletion and key bindings
if test "$(which fzf)"; then
    echo "Installing fzf autocomplete and key bindings..."
    "$(brew --prefix)"/opt/fzf/install
fi

# Initialize miniconda
conda init "$(basename "${SHELL}")"

# Disable Microsoft AutoUpdate
launchctl disable gui/"$(id -u)"/com.microsoft.update.agent
