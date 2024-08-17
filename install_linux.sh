#!/usr/bin/env bash

conda_setup_path="${DOTFILES_ROOT}/scripts/conda_setup.sh"
chmod 755 "${conda_setup_path}"
sh -c "${conda_setup_path}"
chmod 644 "${conda_setup_path}"

exit 0
