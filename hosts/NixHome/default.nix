{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "NixHome";

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
  hardware.graphics.enable = true;
}
