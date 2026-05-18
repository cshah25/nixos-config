{ config, lib, ... }:

{
  options.sys.virtualisation.enable = lib.mkEnableOption "Virtualisation";

  config = lib.mkIf config.sys.virtualisation.enable {
    virtualisation.docker.enable = true;
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
