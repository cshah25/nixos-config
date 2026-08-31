{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.sys.desktop;
in
{
  imports = [
    inputs.mangowm.nixosModules.mango
    inputs.noctalia-greeter.nixosModules.default
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

    # Use SDDM when KDE Plasma is enabled
    services.displayManager.sddm.enable = lib.mkDefault cfg.plasma.enable;
    services.desktopManager.plasma6.enable = cfg.plasma.enable;

    # Use GDM when GNOME is enabled
    services.displayManager.gdm.enable = lib.mkDefault (cfg.gnome.enable && !cfg.plasma.enable);
    services.desktopManager.gnome.enable = cfg.gnome.enable;

    # Use Noctalia Greeter for standalone compositors (Niri, Mango, Hyprland) when no full DE is active
    programs.noctalia-greeter = {
      enable = lib.mkDefault ((cfg.niri.enable || cfg.mango.enable || cfg.hyprland.enable) && !cfg.plasma.enable && !cfg.gnome.enable);
      greeter-args = lib.mkDefault "";
      settings = {
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = 24;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
        keyboard = {
          layout = "us";
        };
      };
    };

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
