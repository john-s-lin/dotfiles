#!/usr/bin/env bash

# Assert ZSH_CUSTOM exists
if [ -z "${ZSH_CUSTOM}" ]; then
  ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
fi

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Download modified passion.zsh-theme from saved config
cp "${HOME}/.dotfiles/config/zsh/themes/passion.zsh-theme" "${ZSH_CUSTOM}"/themes/

# Download zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions

# Download zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting

exit 0
