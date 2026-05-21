{ config, pkgs, osConfig, ... }:

let
  # Base packages (always installed)
  basePackages = with pkgs; [
    xev
    thunar
  ];
in
{
  home.packages = basePackages
    ++ (if osConfig.sys.desktop.plasma.enable then [
         pkgs.kdePackages.kamoso
       ] else []);

  programs.home-manager.enable = true;
}
