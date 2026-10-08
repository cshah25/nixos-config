{ config, inputs, pkgs, pkgs-stable, osConfig, ... }:

{
  home.packages = if osConfig.sys.apps.enable then [ 
    pkgs.brave-origin
    pkgs-stable.spotify 
    pkgs-stable.obsidian 
    pkgs.nextcloud-client
    pkgs.nextcloud-talk-desktop
    pkgs.equibop
    pkgs.vlc
  ] else [];
}
