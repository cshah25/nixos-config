{
  config,
  lib,
  pkgs,
  osConfig,
  flakeDir,
  ...
}:

let
  # Static config files link straight into the repo, so edits apply without a rebuild
  # (adding or removing a file in dotfiles/niri/cfg still needs one)
  repoLink =
    path: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/users/rayu/dotfiles/niri/${path}";
  cfgFiles = lib.mapAttrs' (
    name: _: lib.nameValuePair "niri/cfg/${name}" { source = repoLink "cfg/${name}"; }
  ) (builtins.readDir ./dotfiles/niri/cfg);

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
  xdg.configFile = cfgFiles // {
    "niri/config.kdl".source = repoLink "config.kdl";

    "niri/cfg/cursor.kdl".text = ''
      cursor {
          xcursor-theme "capitaine-cursors"
          xcursor-size ${toString osConfig.sys.desktop.cursorSize}
      }
    '';

    "niri/cfg/display.kdl".text = lib.concatMapStringsSep "\n" outputBlock osConfig.sys.monitors;
  };
}
