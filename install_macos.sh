#!/usr/bin/env bash

if [[ "$OS" != "Darwin" ]]; then
	echo "Oops! $OS is not MacOS. Running the wrong install script. Exiting..."
	exit 1
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
chmod u+x "$(pwd)"/scripts/zsh_setup.sh
sh -c "$(pwd)"/scripts/zsh_setup.sh

# Install fzf autocompletion and key bindings
if test "$(which fzf)"; then
	echo "Installing fzf autocomplete and key bindings..."
	"$(brew --prefix)"/opt/fzf/install
fi

# Initialize miniconda
conda init "$(basename "${SHELL}")"

# Disable Microsoft AutoUpdate
launchctl disable gui/"$(id -u)"/com.microsoft.update.agent

exit 0
