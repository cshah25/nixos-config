{ lib, pkgs, ... }:
{
  services.desktopManager.plasma6.enable = lib.mkForce false;
  
  # Remove kate (KDE app) from user packages since plasma is gone
  users.users.rayu.packages = lib.mkForce [];
  
  # Faster boot
  systemd.services.NetworkManager-wait-online.enable = false;
}
