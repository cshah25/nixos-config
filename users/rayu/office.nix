{ config, pkgs, pkgs-stable, osConfig, ... }:

{
  home.packages = if osConfig.sys.office.enable then [ 
    pkgs-stable.libreoffice 
  ] else [];
}
