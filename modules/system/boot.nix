{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.sys.boot.windows;
in
{
  options.sys.boot.windows = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Add a Windows boot entry to Limine on this host.";
    };
    espUuid = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Filesystem UUID of the Windows ESP for this host.";
    };
  };

  config = lib.mkMerge [
    {
      boot.loader.limine = {
        enable = true;
        secureBoot.enable = true;
      };
      boot.loader.efi.canTouchEfiVariables = true;
      # Hosts pick a CPU-tuned kernel from pkgs.cachyosKernels.*
      boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

      # pinned: builds against the flake's own nixpkgs so the binary cache hits
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
    }

    # Pond's boot look: quiet boot into its Plymouth animation (also shown on shutdown and
    # restart), and a Limine menu in Pond's plum and lilac
    (lib.mkIf (config.sys.desktop.shell == "pond") {
      boot.plymouth = {
        enable = true;
        theme = "pond";
        themePackages = [ pkgs.pond-boot ];
      };

      boot.consoleLogLevel = 3;
      boot.kernelParams = [
        "quiet"
        "rd.udev.log_level=3"
        "udev.log_level=3"
        "rd.systemd.show_status=auto"
        "systemd.show_status=auto"
        "vt.global_cursor_default=0"
      ];

      boot.loader.limine.style = {
        wallpapers = [ "${pkgs.pond-boot}/share/pond/limine-wallpaper.png" ];
        interface = {
          branding = "Choose what to start";
          brandingColor = "CBA6F7";
          helpColor = "745888";
          helpColorBright = "CBE25B";
        };
        graphicalTerminal = {
          font.scale = "2x2";
          foreground = "CBA6F7";
          brightForeground = "CBE25B";
          # Fully transparent so the wallpaper shows behind the menu
          background = "FF1C0919";
          margin = 0;
        };
      };
    })

    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.espUuid != null;
          message = "sys.boot.windows.enable is set but espUuid is null";
        }
      ];

      boot.loader.limine.extraEntries = ''
        /Windows
          protocol: efi
          path: uuid(${cfg.espUuid}):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    })
  ];
}
