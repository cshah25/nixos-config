{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.sys.desktop;
in
{
  imports = [
    inputs.mangowm.nixosModules.mango
  ];

  options.sys.desktop = {
    plasma.enable = lib.mkEnableOption "KDE Plasma";
    gnome.enable = lib.mkEnableOption "GNOME";
    niri.enable = lib.mkEnableOption "Niri";
    hyprland.enable = lib.mkEnableOption "Hyprland";
    mango.enable = lib.mkEnableOption "Mango WM";
  };

  config = lib.mkIf (cfg.plasma.enable || cfg.gnome.enable || cfg.niri.enable || cfg.hyprland.enable || cfg.mango.enable) {
    services.xserver.enable = true;

    # Use SDDM when any wlroots compositor is enabled (GDM can't launch them reliably)
    services.displayManager.sddm.enable = lib.mkDefault (cfg.plasma.enable || cfg.hyprland.enable || cfg.niri.enable || cfg.mango.enable);
    services.desktopManager.plasma6.enable = cfg.plasma.enable;

    # Only use GDM when GNOME is the sole desktop (no wlroots compositors active)
    services.displayManager.gdm.enable = lib.mkDefault (cfg.gnome.enable && !cfg.hyprland.enable && !cfg.niri.enable && !cfg.mango.enable);
    services.desktopManager.gnome.enable = cfg.gnome.enable;

    programs.niri.enable = cfg.niri.enable;
    services.upower.enable = lib.mkDefault (cfg.niri.enable || cfg.mango.enable);

    programs.hyprland.enable = cfg.hyprland.enable;

    programs.mango.enable = cfg.mango.enable;

    # Configure portal-wlr output chooser for screen sharing
    xdg.portal.wlr.settings = lib.mkIf cfg.mango.enable {
      screencast = {
        chooser_type = "simple";
        chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
      };
    };

    systemd.user.targets.mango-session = lib.mkIf cfg.mango.enable {
      description = "Mango WM Session";
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
