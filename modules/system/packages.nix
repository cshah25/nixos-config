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
      man-pages
      curl
      wget
      sbctl
      brightnessctl
      xwayland-satellite
    ] ++ lib.optionals (config.sys.desktop.gnome.enable && config.networking.hostName == "NixHome") [
      ddcutil
    ];
  };
}
