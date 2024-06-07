#!/usr/bin/env bash
#
# Credits to No Boilerplate (Tris) for the idea and most of this script. 

set -e
pushd /etc/nixos

nvim configuration.nix 

# early return if there's no changes 
if git diff --quiet '*.nix'; then
	echo "No changes detected, exiting."
	popd 
	exit 0 
fi

# Autoformat nix files
alejandra . &>/dev/null \
	|| (alejandra . ; echo "formatting failed!" && exit 1)

# show changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."
sudo nixos-rebuild switch &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)

current=$(nixos-rebuild list-generations | grep current)
git commit -am "$current"

# push to origin if connected to the internet
ping -c 1 8.8.8.8 &> /dev/null && git push origin main 

popd

notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available
