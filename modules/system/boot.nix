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
