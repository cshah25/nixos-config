{ config, lib, pkgs, pkgs-stable, inputs, ... }:

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
      sbctl
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
      rclone
      wl-clipboard
    ] ++ lib.optionals (config.sys.desktop.niri.enable || config.sys.desktop.mango.enable) [
      inputs.noctalia.packages.${pkgs.system}.default
    ] ++ lib.optionals config.sys.desktop.hyprland.enable [
      kitty
    ] ++ lib.optionals config.sys.desktop.plasma.enable [
      kdePackages.kwalletmanager
    ] ++ lib.optionals config.sys.desktop.gnome.enable [
      gnomeExtensions.blur-my-shell
      gnomeExtensions.caffeine
      gnomeExtensions.clipboard-indicator
      gnomeExtensions.dash-to-dock
      gnomeExtensions.appindicator
      gnomeExtensions.multi-monitor-bar
      gnomeExtensions.removable-drive-menu
    ] ++ lib.optionals (config.sys.desktop.gnome.enable && config.networking.hostName == "NixHome") [
      ddcutil
      gnomeExtensions.brightness-control-using-ddcutil
    ];
  };
}
