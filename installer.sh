#!/usr/bin/env bash

set -e

# Ask for hostname
read -rp "Enter new hostname: " NEW_HOSTNAME

if [[ -z "$NEW_HOSTNAME" ]]; then
  echo "Hostname cannot be empty."
  exit 1
fi

echo "Updating hostname to: $NEW_HOSTNAME"

# Replace hostname in configuration.nix
sed -i "s/networking.hostName = \".*\";/networking.hostName = \"$NEW_HOSTNAME\";/g" configuration.nix

# Replace hostname in flake.nix (common patterns)
sed -i "s/hostname = \".*\"/hostname = \"$NEW_HOSTNAME\"/g" flake.nix
sed -i "s/\".*\" = nixpkgs.lib.nixosSystem/\"$NEW_HOSTNAME\" = nixpkgs.lib.nixosSystem/g" flake.nix

echo "Files updated."

# Rebuild system
echo "Rebuilding NixOS..."
sudo nixos-rebuild switch --impure --flake .

echo "Done."
