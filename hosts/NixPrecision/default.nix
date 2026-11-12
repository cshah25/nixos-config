{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.dell-precision-5570
  ];

  sys = {
    desktop = {
      plasma.enable = false;
      gnome.enable = false;
      niri.enable = false;
      mango.enable = true;
      umbriel.enable = false;
    };
    monitors = [
      {
        output = "eDP-1";
        width = 1920;
        height = 1200;
        refresh = 59.88;
        x = 0;
        y = 1080;
      }
      {
        output = "HDMI-A-1";
        width = 1920;
        height = 1080;
        refresh = 60;
        x = 0;
        y = 0;
      }
    ];
    boot.theme.resolution = "1920x1200"; # eDP-1 panel
    gaming.enable = true;
    virtualisation.enable = true;
    apps.enable = true;
    office.enable = true;
    development.enable = true;
    services = {
      remote.enable = true;
      tailscale.enable = true;
      fwupd.enable = true;
      displaylink.enable = false;
      rgb.enable = false;
      ollama.enable = false;
      onedrive.enable = false;
      nextcloud-mount.enable = false;
      printing.enable = true;
    };
  };

  system.stateVersion = "25.11";

  # Ryzen 7 250 is Zen 4 (Hawk Point); EEVDF is CachyOS's general-purpose default
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;

  systemd.services.NetworkManager-wait-online.enable = false;

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/705be8ac-6fb3-4858-b83d-6a6e92b1c9d2";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };

  hardware.graphics.enable = true;
}
