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
      
      packages = [] 
        ++ (if config.sys.apps.enable then [ "net.waterfox.waterfox" ] else [])
        ++ (if config.sys.office.enable then [ "org.onlyoffice.desktopeditors" ] else []);

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
