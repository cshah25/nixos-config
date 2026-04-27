{ lib, pkgs, config, ... }:
{
  services.desktopManager.plasma6.enable = lib.mkForce false;
  users.users.rayu.packages = lib.mkForce [];
  systemd.services.NetworkManager-wait-online.enable = false;

  boot.blacklistedKernelModules = [ "nouveau" "nvidia" "nvidia_drm" "nvidia_modeset" ];
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.nvidia.modesetting.enable = lib.mkForce false;
}