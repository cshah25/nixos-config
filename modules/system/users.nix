{ config, lib, pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;

  users.users.rayu = {
    isNormalUser = true;
    description = "Chirayu Shah";
    extraGroups = [ "networkmanager" "wheel" "adbusers" ]
      ++ lib.optionals config.sys.virtualisation.enable [ "docker" "libvirtd" "kvm" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
