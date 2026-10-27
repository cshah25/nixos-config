{
  config,
  lib,
  pkgs,
  ...
}:

let
  # Monitors with a separate gaming refresh rate
  fastMonitors = lib.filter (m: m.gamingRefresh != null) config.sys.monitors;

  selector =
    m:
    if m.output != null then
      ".name == ${builtins.toJSON m.output}"
    else
      ".make == ${builtins.toJSON m.make} and .model == ${builtins.toJSON m.model} and .serial == ${builtins.toJSON m.serial}";

  setMode =
    hz: m:
    "set_mode ${lib.escapeShellArg (selector m)} ${toString m.width} ${toString m.height} ${builtins.toJSON hz}";

  # Steam launch option: hirefresh %command%
  # Raises the monitors' refresh rate while the game runs and restores it on exit,
  # so the desktop stays at the more stable everyday rate.
  hirefresh = pkgs.writeShellScriptBin "hirefresh" ''
    WLR=${pkgs.wlr-randr}/bin/wlr-randr
    JQ=${pkgs.jq}/bin/jq

    # set_mode <jq output selector> <width> <height> <refresh>
    # Picks the advertised mode closest to <refresh> so wlr-randr gets an exact match.
    set_mode() {
      local json out hz
      json=$("$WLR" --json) || return
      out=$("$JQ" -r "first(.[] | select($1) | .name) // empty" <<<"$json")
      [ -n "$out" ] || return
      hz=$("$JQ" -r --arg o "$out" --argjson w "$2" --argjson h "$3" --argjson hz "$4" '
        .[] | select(.name == $o) | [.modes[] | select(.width == $w and .height == $h)]
        | min_by(.refresh - $hz | if . < 0 then -. else . end) | .refresh // empty' <<<"$json")
      [ -n "$hz" ] && "$WLR" --output "$out" --mode "$2x$3@''${hz}Hz"
    }

    restore() {
      ${lib.concatMapStringsSep "\n  " (m: setMode m.refresh m) fastMonitors}
    }

    ${lib.concatMapStringsSep "\n" (m: setMode m.gamingRefresh m) fastMonitors}
    trap restore EXIT
    "$@"
  '';
in
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

    # Launch option: gamemoderun %command%
    # Switches the CPU to the performance governor and pins the GPU clocks high while a game runs.
    programs.gamemode = {
      enable = true;
      settings = {
        general.renice = 10;
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 2; # /sys/class/drm/card2 is the AMD dGPU (card1 is the Intel iGPU)
          amd_performance_level = "high";
        };
      };
    };

    environment.systemPackages = lib.optional (fastMonitors != [ ]) hirefresh;
  };
}
