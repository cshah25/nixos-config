{ config, lib, pkgs-stable, inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  config = {
    programs.zsh.enable = true;
    programs.dconf.enable = true;
    programs.nix-ld.enable = true;

    # If apps are enabled, we might want to configure firefox specifically
    programs.firefox = lib.mkIf config.sys.apps.enable {
      enable = true;
      package = pkgs-stable.firefox;
    };

    services.flatpak = {
      remotes = lib.mkOptionDefault [{ 
        name = "flathub"; 
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }];
      
      packages = [
        "org.kde.index"
      ] 
        ++ (if config.sys.apps.enable then [ "net.waterfox.waterfox" ] else [])
        ++ (if config.sys.office.enable then [ "org.onlyoffice.desktopeditors" ] else []);
    };
  };
}
