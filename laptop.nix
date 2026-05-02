{ lib, pkgs, config, ... }:
{
  # services.desktopManager.plasma6.enable = lib.mkForce false;
  # users.users.rayu.packages = lib.mkForce [];
  systemd.services.NetworkManager-wait-online.enable = false;

  # Load the Nvidia driver (required for power management)
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Required for Niri
    modesetting.enable = true;
    # Open source drivers
    open = true; 

    # Enable the Nvidia settings menu
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
      
      # hardware Bus IDs
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0"; 
    };
  };
}