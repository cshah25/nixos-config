{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

lib.mkIf osConfig.sys.apps.enable {
  home.packages = [
    pkgs.brave-origin
    pkgs.stable.spotify
    pkgs.stable.obsidian
    pkgs.nextcloud-client
    pkgs.nextcloud-talk-desktop
    pkgs.equibop
    pkgs.vlc
  ];
}
