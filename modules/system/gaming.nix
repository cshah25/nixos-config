{ config, lib, ... }:

{
  options.sys.gaming.enable = lib.mkEnableOption "Gaming support";

  config = lib.mkIf config.sys.gaming.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
