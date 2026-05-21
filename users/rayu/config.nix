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
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/jpg" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
    };
  };

  dconf.enable = true;
  gtk.enable = true;
}
