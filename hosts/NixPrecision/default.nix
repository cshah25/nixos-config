{inputs, ...}:

{
  imports = [
    ./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.dell-precision-5570
  ];

  networking.hostName = "NixPrecision";

  sys = {
    desktop = {
      plasma.enable = true;
      niri.enable = true;
    };
    gaming.enable = false;
    virtualisation.enable = true;
    apps.enable = true;
    office.enable = true;
    development.enable = true;
    services = {
      ssh.enable = true;
      tailscale.enable = true;
    };
  };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/103c2982-e6b3-484e-bc22-3a32504cbd63";
    fsType = "ext4";
    options = [ "defaults" "nofail" "X-systemd.device-timeout=5s"];
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    open = true;

    powerManagement = {
      enable = true;
      finegrained = true;
    };
    
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
