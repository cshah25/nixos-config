{ config, pkgs, pkgs-stable, osConfig, ... }:

let
  # Base packages (always installed)
  basePackages = with pkgs; [
    xev
  ];
in
{
  home.packages = basePackages
    ++ (if osConfig.sys.apps.enable then [ 
         pkgs-stable.brave 
         pkgs-stable.spotify 
         pkgs-stable.obsidian 
         pkgs-stable.nextcloud-client
         pkgs-stable.teams-for-linux
         pkgs.equibop
       ] else [])
    ++ (if osConfig.sys.office.enable then [ 
         pkgs-stable.libreoffice 
       ] else [])
    ++ (if osConfig.sys.development.enable then [ 
         pkgs-stable.vscode 
         pkgs-stable.android-studio 
         pkgs.nodejs 
         pkgs.go 
         pkgs.antigravity 
       ] else [])
    ++ (if osConfig.sys.gaming.enable then [ 
         pkgs.heroic
       ] else [])
    ++ (if osConfig.sys.desktop.plasma.enable then [
         pkgs.kdePackages.kamoso
       ] else []);

  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    withPython3 = false;
    withRuby = false;
  };

  programs.zsh.enable = true;
}
