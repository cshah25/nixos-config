{ inputs, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
  ];

  sys = {
    desktop = {
      plasma.enable = false;
      gnome.enable = false;
      niri.enable = false;
      mango.enable = true;
    };
    monitors = [
      {
        output = "eDP-1";
        width = 1920;
        height = 1200;
        refresh = 60.003;
        x = 0;
        y = 1080;
      }
    ];
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
      onedrive.enable = true;
      printing.enable = true;
    };
  };

  system.stateVersion = "25.11";

  systemd.services.NetworkManager-wait-online.enable = false;

  # The E14's mic-mute LED stays lit even when the mic is unmuted
  systemd.services.disable-mute = {
    description = "Disable Mute LED";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "disable-micmute-led" ''
        echo 0 > /sys/class/leds/platform::micmute/brightness
      '';
      RemainAfterExit = true;
    };
  };
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
