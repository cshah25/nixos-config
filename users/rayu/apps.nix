{ config, inputs, pkgs, pkgs-stable, osConfig, ... }:

{
  home.packages = if osConfig.sys.apps.enable then [ 
    pkgs-stable.brave 
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs-stable.spotify 
    pkgs-stable.obsidian 
    pkgs-stable.nextcloud-client
    pkgs-stable.nextcloud-talk-desktop
    pkgs.equibop
    pkgs.vlc
    pkgs.onedrive
  ] else [];
}
