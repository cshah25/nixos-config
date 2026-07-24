{ config, pkgs, pkgs-stable, osConfig, lib, ... }:

let
  mailspring-wrapped = pkgs.symlinkJoin {
    name = "mailspring-wrapped";
    paths = [ pkgs-stable.mailspring ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/mailspring \
        --add-flags '--password-store="gnome-libsecret"'
    '';
  };
in
lib.mkIf osConfig.sys.office.enable {
  home.packages = [ 
    pkgs-stable.libreoffice 
    pkgs-stable.zoom-us
    mailspring-wrapped
  ];

  xdg.desktopEntries.Mailspring = {
    name = "Mailspring";
    comment = "The best email app for people and teams.";
    exec = "mailspring --password-store=\"gnome-libsecret\" %U";
    icon = "mailspring";
    terminal = false;
    categories = [ "Network" "Email" ];
    mimeType = [ "x-scheme-handler/mailto" "x-scheme-handler/mailspring" ];
  };
}
