{ config, pkgs, ... }:

{
  xdg.configFile = {
    "gtk-3.0/settings.ini".source = ./dotfiles/gtk-3.0/settings.ini;
    "gtk-4.0/settings.ini".source = ./dotfiles/gtk-4.0/settings.ini;
    "Kvantum/kvantum.kvconfig".source = ./dotfiles/Kvantum/kvantum.kvconfig;
    "qt5ct/qt5ct.conf".source = ./dotfiles/qt5ct/qt5ct.conf;
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
  };

  dconf.enable = true;
  gtk.enable = true;
}
