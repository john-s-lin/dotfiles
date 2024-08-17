#!/usr/bin/env bash

# NOTE: this installs miniforge3
ARCH=$(uname -m)

mkdir -p "${HOME}/.miniforge3"
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-${ARCH}.sh"
bash "${HOME}/.miniforge3/Miniforge3-$(uname)-${ARCH}.sh"
rm -rf "${HOME}/.miniforge3/Miniforge3-$(uname)-${ARCH}.sh"

exit 0
