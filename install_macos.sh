#!/usr/bin/env bash

if [[ "${PLATFORM}" != "Darwin" ]]; then
	echo "Oops! ${PLATFORM} is not MacOS. Running the wrong install script. Exiting..."
	exit 1
fi

# Install Homebrew
echo "Checking for Homebrew..."
if test ! "$(which brew)"; then
	echo "Installing Homebrew..."
	NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	echo "Homebrew installed!"
else
	echo "$(brew --version) already installed."
fi

# Check brew doctor
brew doctor

# Install brew packages from Brewfile
brew bundle install -v --file="${DOTFILES_ROOT}"/Brewfile

# Install fzf autocompletion and key bindings
if command -v fzf &>/dev/null; then
	echo "Installing fzf autocomplete and key bindings..."
	"$(brew --prefix)"/opt/fzf/install
fi

# Setup macOS default config
chmod 755 "${DOTFILES_ROOT}/scripts/macos_setup.sh"
sh -c "${DOTFILES_ROOT}/scripts/macos_setup.sh"
chmod 644 "${DOTFILES_ROOT}/scripts/macos_setup.sh"

# Disable Microsoft AutoUpdate
launchctl disable gui/"$(id -u)"/com.microsoft.update.agent

exit 0
