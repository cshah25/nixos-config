{ config, pkgs, osConfig, ... }:

{
  home.packages = if osConfig.sys.gaming.enable then [ 
    pkgs.heroic
  ] else [];
}
