{ config, lib, ... }:

let
  cfg = config.sys.desktop;
in
{
  options.sys.desktop = {
    plasma.enable = lib.mkEnableOption "KDE Plasma";
    gnome.enable = lib.mkEnableOption "GNOME";
    niri.enable = lib.mkEnableOption "Niri";
    hyprland.enable = lib.mkEnableOption "Hyprland";
  };

  config = lib.mkIf (cfg.plasma.enable || cfg.gnome.enable || cfg.niri.enable || cfg.hyprland.enable) {
    services.xserver.enable = true;

    services.displayManager.sddm.enable = lib.mkDefault (cfg.plasma.enable || ((cfg.hyprland.enable || cfg.niri.enable) && !cfg.gnome.enable));
    services.desktopManager.plasma6.enable = cfg.plasma.enable;

    services.displayManager.gdm.enable = lib.mkDefault cfg.gnome.enable;
    services.desktopManager.gnome.enable = cfg.gnome.enable;

    programs.niri.enable = cfg.niri.enable;
    services.upower.enable = cfg.niri.enable;

    programs.hyprland.enable = cfg.hyprland.enable;

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
