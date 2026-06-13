{ config, lib, pkgs, pkgs-stable, ... }:

{
  options.sys = {
    apps.enable = lib.mkEnableOption "General GUI applications";
    office.enable = lib.mkEnableOption "Office productivity tools";
    development.enable = lib.mkEnableOption "Development tools";
  };

  config = {
    environment.systemPackages = with pkgs; [
      vim
      curl
      wget
      tree
      alacritty
      distrobox
      bat
      tmux
      fastfetch
      noctalia-shell
      swayidle
      brightnessctl
      playerctl
      adwaita-icon-theme
      xwayland-satellite
      python3
      ripgrep
      wayland-pipewire-idle-inhibit
      wakeonlan
      kdePackages.kwalletmanager
      papirus-icon-theme
      (texlive.combine {
        inherit (texlive) scheme-medium preprint titlesec marvosym enumitem;
      })
    ];
  };
}
