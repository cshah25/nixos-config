{ config, pkgs, ... }:

{
  xdg.configFile = {
	 "gtk-3.0".source = ./dotfiles/gtk-3.0;
	 "gtk-4.0".source = ./dotfiles/gtk-4.0;
   "Kvantum".source = ./dotfiles/Kvantum;
	 "niri".source = ./dotfiles/niri;
	 "qt5ct".source = ./dotfiles/qt5ct;
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
