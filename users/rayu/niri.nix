{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  # Rendered from sys.monitors in the host config
  outputBlock = m: ''
    output "${if m.output != null then m.output else "${m.make} ${m.model} ${m.serial}"}" {
        mode "${toString m.width}x${toString m.height}@${builtins.toJSON m.refresh}"
        scale ${builtins.toJSON m.scale}
        position x=${toString m.x} y=${toString m.y}
    }
  '';
in
{
  xdg.configFile = {
    "niri" = {
      source = ./dotfiles/niri;
      recursive = true;
    };

    "niri/cfg/cursor.kdl".text = ''
      cursor {
          xcursor-theme "capitaine-cursors"
          xcursor-size ${toString osConfig.sys.desktop.cursorSize}
      }
    '';

    "niri/cfg/display.kdl".text = lib.concatMapStringsSep "\n" outputBlock osConfig.sys.monitors;
  };
}
