{ config, pkgs, ... }:

{
  imports = [
    ./packages.nix
    ./config.nix
    ./services.nix
  ];
  home.username = "rayu";
  home.homeDirectory = "/home/rayu";
  home.stateVersion = "25.11";
}
