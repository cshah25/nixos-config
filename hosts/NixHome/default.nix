{ inputs, ... }: 

{
  imports = [
    ./hardware-configuration.nix
    (import "${inputs.nixos-hardware}/common/cpu/intel")
    (import "${inputs.nixos-hardware}/common/gpu/amd")
    (import "${inputs.nixos-hardware}/common/pc/ssd")
  ];

  networking.hostName = "NixHome";

  sys = {
    desktop = {
      plasma.enable = false;
      gnome.enable = false;
      niri.enable = true;
      hyprland.enable = false;
    };
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
      rgb.enable = true;
      ollama.enable = true;
    };
  };

  networking = {
    interfaces = {
    enp7s0 = {
        wakeOnLan.enable = true;
      };
    };
    firewall = {
      allowedUDPPorts = [ 9 ];
    };
  };
  # 2TB SSD
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/1456bb2e-df41-479f-acae-868420c1bc3a";
    fsType = "ext4";
    options = [ "defaults" "nofail" "X-systemd.device-timeout=5s" ];
  };

  fileSystems."/mnt/storage2" = {
    device = "/dev/disk/by-uuid/7b49a9b6-3126-4a4e-9ef1-23f3223d377d";
    fsType = "ext4";
    options = [ "defaults" "nofail" "X-systemd.device-timeout=5s" ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics.enable = true;
}
