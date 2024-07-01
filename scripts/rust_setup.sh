#!/usr/bin/env bash

# Headless Rust installation
if ! command -v rustc &>/dev/null; then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
	echo "Rust is already installed."
	rustc --version
fi

exit 0
