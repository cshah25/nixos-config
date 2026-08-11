{ config, pkgs, osConfig, ... }:

let
  isPlasma = osConfig.sys.desktop.plasma.enable;

  pdfViewer = if isPlasma then [ "org.kde.okular.desktop" ] else [ "org.gnome.Papers.desktop" ];

  imageViewer = if isPlasma then [ "org.kde.gwenview.desktop" ] else [ "org.gnome.Loupe.desktop" ];

  audioPlayer = if isPlasma then [ "org.kde.elisa.desktop" ] else [ "org.gnome.Decibels.desktop" ];

  archiveManager = if isPlasma then [ "org.kde.ark.desktop" ] else [ "org.gnome.Nautilus.desktop" ];

  fileManager = if isPlasma then ["org.kde.dolphin.desktop"] else [ "org.gnome.Nautilus.desktop" ];
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

    defaultApplications = {
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];

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
