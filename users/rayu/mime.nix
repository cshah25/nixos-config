{ config, pkgs, osConfig, ... }:

let
  isGnome = osConfig.sys.desktop.gnome.enable;
  isPlasma = osConfig.sys.desktop.plasma.enable;

  pdfViewer = if isGnome then [ "org.gnome.Papers.desktop" ]
              else if isPlasma then [ "org.kde.okular.desktop" ]
              else [ "org.kde.okular.desktop" ];

  imageViewer = if isGnome then [ "org.gnome.Loupe.desktop" ]
                else if isPlasma then [ "org.kde.gwenview.desktop" ]
                else [ "org.kde.gwenview.desktop" ];

  audioPlayer = if isGnome then [ "org.gnome.Decibels.desktop" ]
                else if isPlasma then [ "org.kde.elisa.desktop" ]
                else [ "org.kde.elisa.desktop" ];

  archiveManager = if isGnome then [ "org.gnome.Nautilus.desktop" ]
                   else if isPlasma then [ "org.kde.ark.desktop" ]
                   else [ "org.kde.ark.desktop" ];

  fileManager = if isGnome then [ "org.gnome.Nautilus.desktop" ]
                 else if isPlasma then [ "org.kde.dolphin.desktop" ]
                 else [ "org.gnome.Nautilus.desktop" ];
in

{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];

      "application/pdf" = pdfViewer;

      "application/toml" = [ "nvim.desktop" ];
      "text/plain" = [ "nvim.desktop" ];
      "text/x-python" = [ "nvim.desktop" ];
      "application/json" = [ "nvim.desktop" ];
      
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
