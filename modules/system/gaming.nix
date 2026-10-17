{ config, lib, pkgs, ... }:

{
  options.sys.gaming.enable = lib.mkEnableOption "Gaming support";

  config = lib.mkIf config.sys.gaming.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };

    programs.gamescope = {
      enable = true;
      capSysNice = false;
    };

    # Steam launch option: /run/current-system/sw/bin/hirefresh %command%
    # Bumps DP-3 to 144Hz while the game runs, back to 60Hz on exit.
    environment.systemPackages = [
      (pkgs.writeShellScriptBin "hirefresh" ''
        OUT=DP-3
        HI=3840x2160@144.001007Hz
        LO=3840x2160@60.000000Hz
        ${pkgs.wlr-randr}/bin/wlr-randr --output "$OUT" --mode "$HI"
        trap '${pkgs.wlr-randr}/bin/wlr-randr --output "$OUT" --mode "$LO"' EXIT
        "$@"
      '')
    ];
  };
}
