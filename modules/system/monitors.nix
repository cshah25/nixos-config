{ config, lib, ... }:

let
  inherit (lib) mkOption types;

  monitor = types.submodule {
    options = {
      output = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Connector name (e.g. eDP-1). Leave null to match by make/model/serial, which survives connector renumbering.";
      };
      make = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      model = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      serial = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
      width = mkOption { type = types.int; };
      height = mkOption { type = types.int; };
      refresh = mkOption {
        type = types.number;
        description = "Everyday refresh rate.";
      };
      gamingRefresh = mkOption {
        type = types.nullOr types.number;
        default = null;
        description = "Refresh rate `hirefresh` switches to while a game runs.";
      };
      scale = mkOption {
        type = types.number;
        default = 1;
      };
      x = mkOption {
        type = types.int;
        default = 0;
      };
      y = mkOption {
        type = types.int;
        default = 0;
      };
    };
  };
in
{
  options.sys.monitors = mkOption {
    type = types.listOf monitor;
    default = [ ];
    description = "Per-host monitor layout, rendered into each compositor's config.";
  };

  config.assertions = map (m: {
    assertion = m.output != null || (m.make != null && m.model != null && m.serial != null);
    message = "sys.monitors: each monitor needs `output` or all of make/model/serial";
  }) config.sys.monitors;
}
