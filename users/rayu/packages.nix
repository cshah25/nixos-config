{ config, pkgs, osConfig, ... }:

let
  # Base packages (always installed)
  basePackages = with pkgs; [
    xev
  ];
in
{
  home.packages = basePackages
    ++ (if osConfig.sys.desktop.plasma.enable then [
         pkgs.kdePackages.kamoso
      ] else [])
    ++ (if osConfig.sys.services.remote.enable then [
        pkgs.moonlight-qt
      ] else [])
    ++ (if osConfig.sys.desktop.gnome.enable then [
         pkgs.gnome-weather
         pkgs.gnome-tweaks
      ] else []);

  programs.home-manager.enable = true;
}
