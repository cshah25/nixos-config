{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./config.nix
    ./services.nix
    ./zsh.nix
    ./git.nix
  ];
  home.username = "rayu";
  home.homeDirectory = "/home/rayu";
  home.stateVersion = "25.11";
}
