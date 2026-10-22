{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    inputs.nix-flatpak.nixosModules.nix-flatpak
  ];

  config = {
    programs.zsh.enable = true;
    programs.dconf.enable = true;
    programs.nix-ld.enable = true;
    # Extra libraries for prebuilt binaries (e.g. .NET GUI apps); adds to nix-ld's default set
    programs.nix-ld.libraries = lib.optionals config.sys.development.enable [
      pkgs.fontconfig
      pkgs.freetype
    ];

    services.flatpak = {
      remotes = lib.mkOptionDefault [
        {
          name = "flathub";
          location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        }
      ];

      packages = [
        "com.github.tchx84.Flatseal"
      ]
      ++ lib.optionals config.sys.desktop.gnome.enable [
        "com.mattjakeman.ExtensionManager"
        "org.gnome.gThumb"
      ]
      ++ lib.optionals config.sys.apps.enable [
        "net.waterfox.waterfox"
        "app.fluxer.Fluxer"
      ]
      ++ lib.optionals config.sys.services.remote.enable [
        "io.github.totoshko88.RustConn"
        "com.rustdesk.RustDesk"
      ];
    };
  };
}
