{ config, lib, ... }:

{
  options.sys.virtualisation.enable = lib.mkEnableOption "Virtualisation";

  config = lib.mkIf config.sys.virtualisation.enable {
    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        mtu = 1440;
        dns = [ "1.1.1.1" "8.8.8.8" ];
      };
    };
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
