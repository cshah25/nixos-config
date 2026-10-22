{ config, lib, pkgs, hostname, osConfig, ... }:

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
    "niri/config.kdl".source = ./dotfiles/niri/config.kdl;
    "niri/cfg/animation.kdl".source = ./dotfiles/niri/cfg/animation.kdl;
    "niri/cfg/autostart.kdl".source = ./dotfiles/niri/cfg/autostart.kdl;
    "niri/cfg/input.kdl".source = ./dotfiles/niri/cfg/input.kdl;
    "niri/cfg/keybinds.kdl".source = ./dotfiles/niri/cfg/keybinds.kdl;
    "niri/cfg/layout.kdl".source = ./dotfiles/niri/cfg/layout.kdl;
    "niri/cfg/rules.kdl".source = ./dotfiles/niri/cfg/rules.kdl;

    "niri/cfg/misc.kdl".text = (builtins.readFile ./dotfiles/niri/cfg/misc.kdl) + ''
      cursor {
          xcursor-theme "capitaine-cursors"
          xcursor-size ${if hostname == "NixPrecision" then "16" else "24"}
      }
    '';

    "niri/cfg/display.kdl".text = lib.concatMapStringsSep "\n" outputBlock osConfig.sys.monitors;
  };
}
