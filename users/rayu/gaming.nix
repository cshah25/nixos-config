{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

lib.mkIf osConfig.sys.gaming.enable {
  home.packages = [
    pkgs.heroic
    pkgs.protonup-qt
  ];
}
