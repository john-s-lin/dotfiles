#!/usr/bin/env bash

# NOTE: this script must be run with sudo privileges

# Set computer hostname and confirm
read -r -p "Set a new hostname: " hostname
echo "Setting hostname to: ${hostname}"

scutil --set HostName "${hostname}"
scutil --set LocalHostName "${hostname}"
scutil --set ComputerName "${hostname}"

# Flush cache
dscacheutil -flushcache

echo "Hostname: $(scutil --get HostName)"
echo "LocalHostName $(scutil --get LocalHostName)"
echo "ComputerName $(scutil --get ComputerName)"

# Enable remote login
printf "\nSetting remote login to 'on'...\n"
systemsetup -setremotelogin on
systemsetup -getremotelogin

# Enable symlinks for .zshrc, .bashrc, .condarc
ln -sfn "$(HOME)/.dotfiles/.zshrc" "$(HOME)/.zshrc"
ln -sfn "$(HOME)/.dotfiles/.bashrc" "$(HOME)/.bashrc"
ln -sfn "$(HOME)/.dotfiles/.condarc" "$(HOME)/.condarc"

# Enable symlinks for iterm2 and nvim
ln -sfn "$(HOME)/.dotfiles/config/iterm2/com.googlecode.iterm2.plist" "$(HOME)/.config/iterm2/com.googlecode.iterm2.plist"
ln -sfn "$(HOME)/.dotfiles/config/nvim" "$(HOME)/.config/nvim"

exit 0
