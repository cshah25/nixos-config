{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "NixPrecision";

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/103c2982-e6b3-484e-bc22-3a32504cbd63";
    fsType = "ext4";
    options = [ "defaults" "nofail" "X-systemd.device-timeout=5s"];
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    
    powerManagement = {
      enable = true;
      finegrained = true;
    };
    
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0"; 
    };
  };
}
