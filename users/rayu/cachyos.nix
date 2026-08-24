{ config, pkgs, username ? "cachy", ... }:

{
  imports = [
    ./apps.nix
    ./dev.nix
    ./office.nix
    ./gaming.nix
    ./git.nix
    ./nvim.nix
    ./zsh.nix
    ./alacritty.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };

  # Generic Linux integration for non-NixOS hosts (CachyOS)
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;

  # Ensure unfree packages (VSCode, Spotify, Obsidian, etc.) are allowed
  nixpkgs.config.allowUnfree = true;
}
