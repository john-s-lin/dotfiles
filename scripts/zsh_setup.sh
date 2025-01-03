#!/usr/bin/env bash

# Ensure .oh-my-zsh is already installed
if [[ -z "${ZSH}" || ! -d "${ZSH}" ]]; then
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Assert ZSH_CUSTOM exists
if [ -z "${ZSH_CUSTOM}" ]; then
	ZSH_CUSTOM="${ZSH}/custom"
fi

# Symlink modified passion theme to ZSH_CUSTOM
ln -s "${HOME}/.dotfiles/config/zsh/themes/passion.zsh-theme" "${ZSH_CUSTOM}"/themes
ln -s "${HOME}/.dotfiles/config/zsh/themes/robbyrussell.zsh-theme" "${ZSH_CUSTOM}"/themes

# Download zsh-autosuggestions plugin
git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}"/plugins/zsh-autosuggestions

# Download zsh-syntax-highlighting plugin
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}"/plugins/zsh-syntax-highlighting

exit 0
