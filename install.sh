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

OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
	echo "Running install script for MacOS..."
	source install_macos.sh
elif [[ "$OS" == "Linux" ]]; then
	echo "Running install script for Linux..."
	source install_linux.sh
else
	echo "Not a supported OS. Exiting..."
	exit 1
fi

sh -c "$(pwd)/scripts/rust_setup.sh"

exit 0
