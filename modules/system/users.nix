{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  users.defaultUserShell = pkgs.zsh;

  users.users.${username} = {
    isNormalUser = true;
    description = "Chirayu Shah";
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals config.sys.virtualisation.enable [
      "docker"
      "libvirtd"
      "kvm"
    ]
    ++ lib.optionals config.sys.hardware.ddc.enable [ "i2c" ];
  };
}
