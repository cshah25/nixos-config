{
  config,
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}:

lib.mkIf osConfig.sys.development.enable {
  home.packages = [
    pkgs.vscode
    #pkgs.stable.android-studio
    pkgs.lefthook
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
    pkgs.stable.typescript-language-server # unstable pnpm-deps hash mismatch (2026-10)
    pkgs.omnisharp-roslyn
    pkgs.vscode-langservers-extracted # HTML, CSS, JSON, ESLint
    pkgs.yaml-language-server
    pkgs.bash-language-server
    pkgs.lua-language-server
    pkgs.dockerfile-language-server
    pkgs.marksman # Markdown
    pkgs.sqls # SQL
    pkgs.tailwindcss-language-server
    pkgs.svelte-language-server
    pkgs.zls # Zig
    pkgs.nil # Nix
    pkgs.taplo # TOML
    pkgs.prisma-language-server # Prisma
    pkgs.texlab # LaTeX
    pkgs.zathura # Minimal PDF viewer for LaTeX live preview
    pkgs.gnumake
    pkgs.stable.texlive.combined.scheme-medium
    pkgs.docker-compose
    pkgs.azuredatastudio
    pkgs.dotnet-sdk_10
    pkgs.openssl
    pkgs.netcoredbg
    pkgs.roslyn-ls
    pkgs.distrobox
    pkgs.claude-code
    inputs.kapsule.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  programs.java.enable = true;
}
