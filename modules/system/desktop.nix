{ config, lib, ... }:

let
  cfg = config.sys.desktop;
in
{
  options.sys.desktop = {
    plasma.enable = lib.mkEnableOption "KDE Plasma";
    niri.enable = lib.mkEnableOption "Niri";
  };

  config = lib.mkIf (cfg.plasma.enable || cfg.niri.enable) {
    services.xserver.enable = true;

    services.displayManager.sddm.enable = lib.mkDefault cfg.plasma.enable;
    services.desktopManager.plasma6.enable = cfg.plasma.enable;

    programs.niri.enable = cfg.niri.enable;

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
