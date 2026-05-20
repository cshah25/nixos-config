{ config, pkgs, pkgs-stable, osConfig, ... }:

{
  home.packages = if osConfig.sys.apps.enable then [ 
    pkgs-stable.brave 
    pkgs-stable.spotify 
    pkgs-stable.obsidian 
    pkgs-stable.nextcloud-client
    pkgs-stable.teams-for-linux
    pkgs.equibop
  ] else [];
}
