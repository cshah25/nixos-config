{ config, pkgs, hostname, ... }:

{
  xdg.configFile = {
    "gtk-3.0/settings.ini".source = ./dotfiles/gtk-3.0/settings.ini;
    "gtk-4.0/settings.ini".source = ./dotfiles/gtk-4.0/settings.ini;
    "Kvantum/kvantum.kvconfig".source = ./dotfiles/Kvantum/kvantum.kvconfig;
    "qt5ct/qt5ct.conf".source = ./dotfiles/qt5ct/qt5ct.conf;

    "niri/config.kdl".source = ./dotfiles/niri/config.kdl;
    "niri/cfg/animation.kdl".source = ./dotfiles/niri/cfg/animation.kdl;
    "niri/cfg/autostart.kdl".source = ./dotfiles/niri/cfg/autostart.kdl;
    "niri/cfg/input.kdl".source = ./dotfiles/niri/cfg/input.kdl;
    "niri/cfg/keybinds.kdl".source = ./dotfiles/niri/cfg/keybinds.kdl;
    "niri/cfg/layout.kdl".source = ./dotfiles/niri/cfg/layout.kdl;
    "niri/cfg/rules.kdl".source = ./dotfiles/niri/cfg/rules.kdl;

    "niri/cfg/misc.kdl".text = (builtins.readFile ./dotfiles/niri/cfg/misc.kdl) + ''
      cursor {
          xcursor-theme "capitaine-cursors"
          xcursor-size ${if hostname == "NixPrecision" then "16" else "24"}
      }
    '';

    "niri/cfg/display.kdl".text = if hostname == "NixHome" then ''
      output "DP-2" {
          mode "3840x2160@144.001"
          scale 1.5
          position x=2560 y=0
      }

      output "DP-3" {
          mode "3840x2160@59.997"
          scale 1.5
          position x=0 y=0
      }
    '' else if hostname == "NixPrecision" then ''
      output "eDP-1" {
          mode "1920x1200@59.950"
          scale 1
          position x=0 y=1080 
      }
    '' else "";
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "capitaine-cursors";
    package = pkgs.capitaine-cursors;
  };

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "text/html" = [ "net.waterfox.waterfox.desktop" ];
      "x-scheme-handler/http" = [ "net.waterfox.waterfox.desktop" ];
      "x-scheme-handler/https" = [ "net.waterfox.waterfox.desktop" ];

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

  dconf.enable = true;
  gtk.enable = true;

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
}
