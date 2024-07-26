#!/usr/bin/env bash

DOTFILES_ROOT="$(pwd)"
export DOTFILES_ROOT

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

PLATFORM="$(uname -s)"
export PLATFORM

if [[ "${PLATFORM}" == "Darwin" ]]; then
	echo "Running install script for MacOS..."
	sh -c install_macos.sh
elif [[ "${PLATFORM}" == "Linux" ]]; then
	echo "Running install script for Linux..."
	sh -c install_linux.sh
else
	echo "Not a supported OS. Exiting..."
	exit 1
fi

unset PLATFORM

# Install oh-my-zsh
chmod u+x "${DOTFILES_ROOT}/scripts/zsh_setup.sh"
sh -c "${DOTFILES_ROOT}/scripts/zsh_setup.sh"

chmod u+x "${DOTFILES_ROOT}/scripts/symlinks.sh"
sh -c "${DOTFILES_ROOT}/scripts/symlinks.sh"

chmod u+x "${DOTFILES_ROOT}/scripts/rust_setup.sh"
sh -c "${DOTFILES_ROOT}/scripts/rust_setup.sh"

unset DOTFILES_ROOT

exit 0
