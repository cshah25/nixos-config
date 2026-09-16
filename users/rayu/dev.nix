{ config, pkgs, pkgs-stable, osConfig, inputs, ... }:

{
  home.packages = if osConfig.sys.development.enable then [ 
    pkgs-stable.vscode 
    #pkgs-stable.android-studio 
    pkgs.android-tools
    pkgs.nodejs 
    pkgs.go 
    pkgs.gcc
    pkgs.clang-tools
    pkgs.gdb
    pkgs.pyright
    pkgs.gopls
    pkgs.rust-analyzer
    pkgs.jdt-language-server
    pkgs.nodePackages.typescript-language-server
    pkgs.omnisharp-roslyn
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
    pkgs.claude-code
    inputs.kapsule.packages.${pkgs.stdenv.hostPlatform.system}.default
  ] else [];

  programs.java.enable = true;
}
