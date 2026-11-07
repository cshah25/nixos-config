{
  lib,
  pkgs,
  osConfig,
  ...
}:

lib.mkIf osConfig.sys.apps.enable {
  home.packages = [
    pkgs.brave-origin
    #pkgs.spotify
    pkgs.feishin
    pkgs.stable.obsidian
    pkgs.nextcloud-client
    pkgs.nextcloud-talk-desktop
    pkgs.equibop
    pkgs.vlc
  ];
}
