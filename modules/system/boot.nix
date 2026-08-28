{ pkgs, ... }:
{
  boot.loader.limine = {
    enable = true;
    secureBoot.enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
