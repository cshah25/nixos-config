{ config, pkgs, hostname, ... }:

{
  xdg.configFile = {
    "hypr/hyprland.conf".source = ./dotfiles/hyprland/hyprland.conf;
    "hypr/cfg/animations.conf".source = ./dotfiles/hyprland/cfg/animations.conf;
    "hypr/cfg/autostart.conf".source = ./dotfiles/hyprland/cfg/autostart.conf;
    "hypr/cfg/input.conf".source = ./dotfiles/hyprland/cfg/input.conf;
    "hypr/cfg/keybinds.conf".source = ./dotfiles/hyprland/cfg/keybinds.conf;
    "hypr/cfg/misc.conf".source = ./dotfiles/hyprland/cfg/misc.conf;
    "hypr/cfg/rules.conf".source = ./dotfiles/hyprland/cfg/rules.conf;
    "hypr/cfg/theme.conf".source = ./dotfiles/hyprland/cfg/theme.conf;

    "hypr/cfg/monitors.conf".text = if hostname == "NixHome" then ''
      monitor=DP-4, 3840x2160@144.001, 2560x0, 1.5
      monitor=DP-2, 3840x2160@60, 0x0, 1.5
    '' else if hostname == "NixPrecision" then ''
      monitor=eDP-1, 1920x1200@59.950, 0x1080, 1
    '' else if hostname == "NixThinkpad" then ''
      monitor=eDP-1, 1920x1200@60.003, 0x1080, 1
    '' else "";
  };
}
