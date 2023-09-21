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

exit 0