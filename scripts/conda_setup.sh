#!/usr/bin/env bash

# NOTE: this installs miniforge3
ARCH=$(uname -m)

miniforge_dir="${HOME}/.miniforge3"

if [[ -d "${miniforge_dir}" ]]; then
    echo "miniforge exists"
    exit 1
fi

echo "Installing miniforge3..."
mkdir -p "${miniforge_dir}"
curl --output-dir "${miniforge_dir}" -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-${ARCH}.sh"
bash "${miniforge_dir}/Miniforge3-$(uname)-${ARCH}.sh"
rm -rf "${miniforge_dir}/Miniforge3-$(uname)-${ARCH}.sh"

exit 0
