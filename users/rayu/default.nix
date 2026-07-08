{ config, pkgs, hostname, ... }:

{
  imports = [
    ./packages.nix
    ./theme.nix
    ./niri.nix
    ./hyprland.nix
    ./mime.nix
    ./services.nix
    ./zsh.nix
    ./git.nix
    ./nvim.nix
    ./alacritty.nix
    ./apps.nix
    ./dev.nix
    ./office.nix
    ./gaming.nix
  ];
  home.username = "rayu";
  home.homeDirectory = "/home/rayu";
  home.stateVersion = "25.11";

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
}
