{ config, pkgs, pkgs-stable, osConfig, ... }:

{
  home.packages = if osConfig.sys.development.enable then [ 
    pkgs-stable.vscode 
    pkgs-stable.android-studio 
    pkgs.nodejs 
    pkgs.go 
    pkgs.antigravity
    pkgs-stable.texlive.combined.scheme-medium
  ] else [];
}
