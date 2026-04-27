{ lib, pkgs, config, ... }:
{
  services.desktopManager.plasma6.enable = lib.mkForce false;
  users.users.rayu.packages = lib.mkForce [];
  systemd.services.NetworkManager-wait-online.enable = false;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}