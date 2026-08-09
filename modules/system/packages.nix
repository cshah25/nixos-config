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
      bat
      tmux
      fastfetch
      swayidle
      brightnessctl
      playerctl
      adwaita-icon-theme
      xwayland-satellite
      python3
      ripgrep
      wayland-pipewire-idle-inhibit
      wakeonlan
      seahorse
      papirus-icon-theme
    ] ++ lib.optionals config.sys.desktop.niri.enable [
      noctalia-shell
    ] ++ lib.optionals config.sys.desktop.hyprland.enable [
      kitty
    ] ++ lib.optionals config.sys.desktop.plasma.enable [
      kdePackages.kwalletmanager
    ];
  };
}
