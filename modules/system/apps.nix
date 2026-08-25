{ config, lib, pkgs-stable, inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  config = {
    programs.zsh.enable = true;
    programs.dconf.enable = true;
    programs.nix-ld.enable = true;

    services.flatpak = {
      remotes = lib.mkOptionDefault [{ 
        name = "flathub"; 
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }];
      
      packages = [ "com.github.tchx84.Flatseal" ]
        ++ lib.optional config.sys.office.enable "org.onlyoffice.desktopeditors"
        ++ lib.optionals config.sys.desktop.gnome.enable [
          "com.mattjakeman.ExtensionManager"
          "org.gnome.gThumb"
        ]
        ++ lib.optionals config.sys.services.remote.enable [
          "io.github.totoshko88.RustConn"
          "com.rustdesk.RustDesk"
        ];

      overrides = {
        "org.onlyoffice.desktopeditors" = {
          Context = {
            sockets = [
              "x11"
              "fallback-x11"
              "!wayland"
            ];
          };
          Environment = {
            QT_QPA_PLATFORM = "xcb";
            NIXOS_OZONE_WL = "";
          };
        };
      };
    };
  };
}
