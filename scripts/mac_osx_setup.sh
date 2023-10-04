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

parent_dir="$(dirname "$(pwd)")"

# Enable symlinks for .zshrc, .bashrc, .condarc
ln -sfn "${parent_dir}/.zshrc" "${HOME}/.zshrc"
ln -sfn "${parent_dir}/.bashrc" "${HOME}/.bashrc"
ln -sfn "${parent_dir}/.condarc" "${HOME}/.condarc"

# Enable s{parent_dir}s for iterm2 and nvim
ln -sfn "${parent_dir}/config/iterm2/com.googlecode.iterm2.plist" "${HOME}/.config/iterm2/com.googlecode.iterm2.plist"
ln -sfn "${parent_dir}/config/nvim" "${HOME}/.config/nvim"

# Set dock orientation to left and tilesize = 36
defaults write com.apple.dock "tilesize" -int 36 &&\
  defaults write com.apple.dock "orientation" -string "left" &&\
  killall Dock

# Show  list view, all file extensions, and show path bar inside Finder
defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv" &&\
  defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true" &&\
  defaults write com.apple.finder "ShowPathbar" -bool "true" &&\
  defaults write com.apple.finder "ShowStatusBar" -bool "true" &&\
  killall Finder

exit 0
