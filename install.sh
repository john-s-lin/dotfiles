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

# Change access mode to u+x, runs the setup script on path passed in as argument 1, then chmod back to rw-r--r--
function run_setup_script() {
	chmod 755 "$1"
	sh -c "$1"
	chmod 644 "$1"
}

# Install oh-my-zsh
zsh_setup_path="${DOTFILES_ROOT}/scripts/zsh_setup.sh"
run_setup_script "$zsh_setup_path"

symlinks_setup_path="${DOTFILES_ROOT}/scripts/symlinks.sh"
run_setup_script "$symlinks_setup_path"

rust_setup_path="${DOTFILES_ROOT}/scripts/rust_setup.sh"
run_setup_script "$rust_setup_path"

unset DOTFILES_ROOT

exit 0
