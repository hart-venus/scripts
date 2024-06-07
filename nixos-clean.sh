#!/usr/bin/env bash
#
# Cleanup script for nix os. 

sudo nix-collect-garbage -d 
sudo nixos-rebuild boot 
