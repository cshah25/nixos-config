{ config, pkgs, ... }:

{
  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = [ "zen.desktop" ];
      "x-scheme-handler/http" = [ "zen.desktop" ];
      "x-scheme-handler/https" = [ "zen.desktop" ];

      "application/pdf" = [ "org.kde.okular.desktop" ];

      "application/toml" = [ "nvim.desktop" ];
      "text/plain" = [ "nvim.desktop" ];
      "text/x-python" = [ "nvim.desktop" ];
      "application/json" = [ "nvim.desktop" ];
      
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/jpg" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
      "image/svg+xml" = [ "org.kde.gwenview.desktop" ];

      "video/mp4" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/x-msvideo" = [ "vlc.desktop" ];

      "audio/mpeg" = [ "org.kde.elisa.desktop" ];
      "audio/flac" = [ "org.kde.elisa.desktop" ];
      "audio/ogg" = [ "org.kde.elisa.desktop" ];
      "audio/wav" = [ "org.kde.elisa.desktop" ];

      "application/zip" = [ "org.kde.ark.desktop" ];
      "application/x-tar" = [ "org.kde.ark.desktop" ];
      "application/gzip" = [ "org.kde.ark.desktop" ];

      "inode/directory" = [ "thunar.desktop" ];
    };
  };
}
