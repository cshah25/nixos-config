{ config, pkgs, pkgs-stable, osConfig, inputs, ... }:

{
  home.packages = if osConfig.sys.development.enable then [ 
    pkgs-stable.vscode 
    #pkgs-stable.android-studio 
    pkgs.android-tools
    pkgs.nodejs 
    pkgs.go 
    pkgs.gcc
    pkgs.gdb
    pkgs.gnumake
    pkgs-stable.texlive.combined.scheme-medium
    pkgs.gnumake
    pkgs.docker-compose
    pkgs.azuredatastudio
    pkgs.dotnet-sdk_10
    pkgs.openssl
    pkgs.netcoredbg
    pkgs.roslyn-ls
    pkgs.fontconfig
    pkgs.freetype
    pkgs.distrobox
    inputs.kapsule.packages.${pkgs.stdenv.hostPlatform.system}.default
  ] else [];

  programs.java.enable = true;
}
