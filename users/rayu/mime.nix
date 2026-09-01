{ config, pkgs, osConfig, ... }:

let
  isPlasma = osConfig.sys.desktop.plasma.enable;

  pdfViewer = if isPlasma then [ "org.kde.okular.desktop" ] else [ "org.gnome.Papers.desktop" ];
  imageViewer = if isPlasma then [ "org.kde.gwenview.desktop" ] else [ "org.gnome.Loupe.desktop" ];
  audioPlayer = if isPlasma then [ "org.kde.elisa.desktop" ] else [ "org.gnome.Decibels.desktop" ];
  archiveManager = if isPlasma then [ "org.kde.ark.desktop" ] else [ "org.gnome.Nautilus.desktop" ];
  fileManager = if isPlasma then [ "org.kde.dolphin.desktop" ] else [ "org.gnome.Nautilus.desktop" ];

  # Target desktop files
  codeEditor = [ "code.desktop" ];
  browser = [ "brave-origin.desktop" ];

  # Helper function to bulk-assign a list of MIME types to a handler
  setMimes = mimes: handler:
    builtins.listToAttrs (map (mime: { name = mime; value = handler; }) mimes);

  # Browser-related MIME types and protocols
  browserMimes = [
    "text/html"
    "application/xhtml+xml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/chrome"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ];

  # Code & configuration file MIME types
  codeMimes = [
    "text/plain"
    "text/markdown"
    "text/x-nix"
    "text/x-c"
    "text/x-c++"
    "text/x-c++src"
    "text/x-csrc"
    "text/x-chdr"
    "text/x-python"
    "text/x-script.python"
    "text/javascript"
    "application/javascript"
    "application/x-javascript"
    "application/typescript"
    "text/typescript"
    "text/x-rust"
    "text/x-go"
    "text/x-java"
    "text/x-java-source"
    "text/x-shellscript"
    "application/x-shellscript"
    "text/x-yaml"
    "application/x-yaml"
    "application/json"
    "application/x-json"
    "text/x-toml"
    "application/toml"
    "text/x-lua"
    "text/x-sql"
    "text/css"
    "text/x-scss"
    "text/x-sass"
    "text/x-diff"
    "application/xml"
    "text/xml"
  ];
in

{
  home.packages = [
    pkgs.nautilus
  ] ++ (if isPlasma then [
    pkgs.kdePackages.okular
    pkgs.kdePackages.gwenview
    pkgs.kdePackages.elisa
    pkgs.kdePackages.ark
    pkgs.kdePackages.dolphin
  ] else [
    pkgs.papers
    pkgs.loupe
    pkgs.decibels
  ]);

  xdg.mimeApps = {
    enable = true;

    defaultApplications = (setMimes browserMimes browser)
      // (setMimes codeMimes codeEditor)
      // {
        "application/pdf" = pdfViewer;
        
        "image/png" = imageViewer;
        "image/jpeg" = imageViewer;
        "image/jpg" = imageViewer;
        "image/gif" = imageViewer;
        "image/webp" = imageViewer;
        "image/svg+xml" = imageViewer;

        "video/mp4" = [ "vlc.desktop" ];
        "video/x-matroska" = [ "vlc.desktop" ];
        "video/webm" = [ "vlc.desktop" ];
        "video/x-msvideo" = [ "vlc.desktop" ];

        "audio/mpeg" = audioPlayer;
        "audio/flac" = audioPlayer;
        "audio/ogg" = audioPlayer;
        "audio/wav" = audioPlayer;

        "application/zip" = archiveManager;
        "application/x-tar" = archiveManager;
        "application/gzip" = archiveManager;

        "inode/directory" = fileManager;
      };
  };
}
