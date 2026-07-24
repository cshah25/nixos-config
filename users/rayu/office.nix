{ config, pkgs, pkgs-stable, osConfig, lib, ... }:

lib.mkIf osConfig.sys.office.enable {
  home.packages = [ 
    pkgs-stable.libreoffice 
    pkgs-stable.zoom-us
    pkgs-stable.mailspring
  ];

  xdg.desktopEntries.mailspring = {
    name = "Mailspring";
    comment = "The best email app for people and teams.";
    exec = "mailspring --password-store=\"gnome-libsecret\" %U";
    icon = "mailspring";
    terminal = false;
    categories = [ "Network" "Email" ];
    mimeType = [ "x-scheme-handler/mailto" "x-scheme-handler/mailspring" ];
  };
}
