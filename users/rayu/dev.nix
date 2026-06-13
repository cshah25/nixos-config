{ config, pkgs, pkgs-stable, osConfig, inputs, ... }:

{
  home.packages = if osConfig.sys.development.enable then [ 
    pkgs-stable.vscode 
    #pkgs-stable.android-studio 
    pkgs.nodejs 
    pkgs.go 
    pkgs.gcc
    pkgs.gnumake
    pkgs.antigravity
    pkgs-stable.texlive.combined.scheme-medium
    pkgs.gnumake
    pkgs.docker-compose
    inputs.kapsule.packages.${pkgs.stdenv.hostPlatform.system}.default
  ] else [];

  programs.java.enable = true;
}
