{ config, pkgs, ... }:

{
  xdg.configFile = {
	 "gtk-3.0/settings.ini".source = ./dotfiles/gtk-3.0/settings.ini;
	 "gtk-4.0/settings.ini".source = ./dotfiles/gtk-4.0/settings.ini;
   "Kvantum/kvantum.kvconfig".source = ./dotfiles/Kvantum/kvantum.kvconfig;
	 "niri".source = ./dotfiles/niri;
	 "qt5ct/qt5ct.conf".source = ./dotfiles/qt5ct/qt5ct.conf;
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # Browser
      "text/html" = [ "net.waterfox.waterfox.desktop" ];
      "x-scheme-handler/http" = [ "net.waterfox.waterfox.desktop" ];
      "x-scheme-handler/https" = [ "net.waterfox.waterfox.desktop" ];

      # PDF
      "application/pdf" = [ "org.kde.okular.desktop" ];

      # Images
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/jpg" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
      "image/svg+xml" = [ "org.kde.gwenview.desktop" ];

      # Video -> VLC
      "video/mp4" = [ "vlc.desktop" ];
      "video/x-matroska" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "video/x-msvideo" = [ "vlc.desktop" ];

      # Audio -> Elisa
      "audio/mpeg" = [ "org.kde.elisa.desktop" ];
      "audio/flac" = [ "org.kde.elisa.desktop" ];
      "audio/ogg" = [ "org.kde.elisa.desktop" ];
      "audio/wav" = [ "org.kde.elisa.desktop" ];

      # Archives
      "application/zip" = [ "org.kde.ark.desktop" ];
      "application/x-tar" = [ "org.kde.ark.desktop" ];
      "application/gzip" = [ "org.kde.ark.desktop" ];

      # File manager
      "inode/directory" = [ "thunar.desktop" ];
    };
  };

  dconf.enable = true;
  gtk.enable = true;
}
