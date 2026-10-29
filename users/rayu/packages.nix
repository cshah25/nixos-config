{
  lib,
  pkgs,
  osConfig,
  ...
}:

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
  home.packages =
    basePackages
    ++ lib.optionals osConfig.sys.desktop.plasma.enable [
      pkgs.kdePackages.kamoso
      pkgs.kdePackages.kwalletmanager
    ]
    ++ lib.optionals (osConfig.sys.desktop.mango.enable || osConfig.sys.desktop.niri.enable) [
      pkgs.noctalia
      pkgs.ddcutil
    ]
    ++ lib.optionals osConfig.sys.desktop.gnome.enable [
      pkgs.gnome-weather
      pkgs.gnome-tweaks
      pkgs.gnomeExtensions.blur-my-shell
      pkgs.gnomeExtensions.caffeine
      pkgs.gnomeExtensions.clipboard-indicator
      pkgs.gnomeExtensions.dash-to-dock
      pkgs.gnomeExtensions.appindicator
      pkgs.gnomeExtensions.multi-monitor-bar
      pkgs.gnomeExtensions.removable-drive-menu
    ]
    ++ lib.optionals (osConfig.sys.desktop.gnome.enable && osConfig.sys.hardware.ddc.enable) [
      pkgs.gnomeExtensions.brightness-control-using-ddcutil
    ];
}
