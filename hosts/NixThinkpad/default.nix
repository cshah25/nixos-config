{inputs, ...}:

{
  imports = [
    ./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
  ];

  networking.hostName = "NixThinkpad";

  sys = {
    desktop = {
      plasma.enable = false;
      gnome.enable = true;
      niri.enable = false;
      hyprland.enable = false;
    };
    gaming.enable = false;
    virtualisation.enable = true;
    apps.enable = true;
    office.enable = true;
    development.enable = true;
    services = {
      remote.enable = true;
      tailscale.enable = true;
      fwupd.enable = true;
      displaylink.enable = false;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.services.disable-mute = {
    description = "Disable Mute LED";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/home/rayu/.local/bin/disable_mute.sh";
      RemainAfterExit = true;
    };    
  };
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/705be8ac-6fb3-4858-b83d-6a6e92b1c9d2";
    fsType = "ext4";
    options = [ "defaults" "nofail" "X-systemd.device-timeout=5s" ];
  };
}
