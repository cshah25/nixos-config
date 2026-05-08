{ config, pkgs, ... }:
{
  home.packages = [
    pkgs.nerd-fonts.meslo-lg
    pkgs.teams-for-linux
    pkgs.vscode
    pkgs.antigravity
    pkgs.libreoffice
    pkgs.onlyoffice-desktopeditors
    pkgs.android-studio
    pkgs.nextcloud-client
    pkgs.brave
    pkgs.spotify
    pkgs.equibop
    pkgs.obsidian
    pkgs.heroic
    pkgs.nodejs
    pkgs.xev
    pkgs.kdePackages.kamoso
  ];

  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    withPython3 = false;
    withRuby = false;
  };

  programs.zsh.enable = true;
}
