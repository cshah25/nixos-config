{ config, lib, pkgs, pkgs-stable, inputs, ... }:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  options.sys = {
    apps.enable = lib.mkEnableOption "General GUI applications";
    office.enable = lib.mkEnableOption "Office productivity tools";
    development.enable = lib.mkEnableOption "Development tools";
  };

  config = {
    programs.zsh.enable = true;
    programs.dconf.enable = true;
    programs.nix-ld.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    environment.systemPackages = with pkgs; [
      sbctl
      vim
      git
      curl
      wget
      tree
      alacritty
      distrobox
      bat
      tmux
      fastfetch
      noctalia-shell
      swayidle
      brightnessctl
      playerctl
      (catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "mauve";
      })
      adwaita-icon-theme
      xwayland-satellite
      python3
      ripgrep
      wayland-pipewire-idle-inhibit
      wakeonlan
    ] ++ (if config.sys.apps.enable then [
      pkgs-stable.firefox
    ] else []);

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
      
      packages = [] 
        ++ (if config.sys.apps.enable then [ "net.waterfox.waterfox" ] else [])
        ++ (if config.sys.office.enable then [ "org.onlyoffice.desktopeditors" ] else [])
        ++ (if config.sys.desktop.plasma.enable then [ "org.kde.index" ] else []);
    };
  };
}
