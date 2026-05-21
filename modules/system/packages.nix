{ config, lib, pkgs, pkgs-stable, ... }:

{
  options.sys = {
    apps.enable = lib.mkEnableOption "General GUI applications";
    office.enable = lib.mkEnableOption "Office productivity tools";
    development.enable = lib.mkEnableOption "Development tools";
  };

  config = {
    environment.systemPackages = with pkgs; [
      sbctl
      vim
      git
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
      (catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      })
      adwaita-icon-theme
      xwayland-satellite
      python3
      ripgrep
      wayland-pipewire-idle-inhibit
      wakeonlan
    ];
  };
}
