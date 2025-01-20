#!/usr/bin/env bash

# Ensure .oh-my-zsh is already installed
if [[ -z "${ZSH}" || ! -d "${ZSH}" ]]; then
	echo "Oh My Zsh not found. Installing..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
	echo "Oh My Zsh already installed."
fi

if [[ -z "${ZSH_CUSTOM}" ]]; then
	ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"
fi

# Symlink modified themes to ZSH_CUSTOM
echo "Creating symlinks for custom themes..."
ln -sf "${HOME}/.dotfiles/config/zsh/themes/passion.zsh-theme" "${ZSH_CUSTOM}/themes/passion.zsh-theme"
ln -sf "${HOME}/.dotfiles/config/zsh/themes/robbyrussell.zsh-theme" "${ZSH_CUSTOM}/themes/robbyrussell.zsh-theme"

# Download zsh-autosuggestions plugin
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
	echo "Installing zsh-autosuggestions plugin..."
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
else
	echo "zsh-autosuggestions plugin already installed."
fi

# Download zsh-syntax-highlighting plugin
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
	echo "Installing zsh-syntax-highlighting plugin..."
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
else
	echo "zsh-syntax-highlighting plugin already installed."
fi

echo "zsh setup complete."

exit 0
