{ config, pkgs, osConfig, ... }:

let
  # Base packages
  basePackages = with pkgs; [
    tree
    bat
    tmux
    fastfetch
    swayidle
    playerctl
    python3
    ripgrep
    fd
    wayland-pipewire-idle-inhibit
    wakeonlan
    wl-clipboard
    rclone
    seahorse
  ];
in
{
  home.packages = basePackages
    ++ (if osConfig.sys.desktop.plasma.enable then [
         pkgs.kdePackages.kamoso
         pkgs.kdePackages.kwalletmanager
      ] else [])
    ++ (if osConfig.sys.services.remote.enable then [
         pkgs.moonlight-qt
      ] else [])
    ++ (if osConfig.sys.desktop.hyprland.enable then [
         pkgs.kitty
      ] else [])
    ++ (if osConfig.sys.desktop.mango.enable || osConfig.sys.desktop.niri.enable then [
         pkgs.noctalia
      ] else [])
    ++ (if osConfig.sys.desktop.gnome.enable then [
         pkgs.gnome-weather
         pkgs.gnome-tweaks
         pkgs.gnomeExtensions.blur-my-shell
         pkgs.gnomeExtensions.caffeine
         pkgs.gnomeExtensions.clipboard-indicator
         pkgs.gnomeExtensions.dash-to-dock
         pkgs.gnomeExtensions.appindicator
         pkgs.gnomeExtensions.multi-monitor-bar
         pkgs.gnomeExtensions.removable-drive-menu
      ] ++ (if osConfig.networking.hostName == "NixHome" then [
         pkgs.gnomeExtensions.brightness-control-using-ddcutil
      ] else [])
    else []);

  programs.home-manager.enable = true;
}
