{
  config,
  lib,
  osConfig,
  flakeDir,
  ...
}:

let
  # Static config files link straight into the repo, so edits apply without a rebuild
  # (adding or removing a file in dotfiles/umbriel/cfg still needs one)
  repoLink =
    path: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/users/rayu/dotfiles/umbriel/${path}";
  cfgFiles = lib.mapAttrs' (
    name: _: lib.nameValuePair "umbriel/cfg/${name}" { source = repoLink "cfg/${name}"; }
  ) (builtins.readDir ./dotfiles/umbriel/cfg);

  # Rendered from sys.monitors in the host config; identity form is "<make> <model> <serial>"
  outputSection =
    m:
    let
      name = if m.output != null then m.output else "${m.make} ${m.model} ${m.serial}";
    in
    ''
      [output.${builtins.toJSON name}]
      mode = "${toString m.width}x${toString m.height}@${builtins.toJSON m.refresh}"
      scale = ${builtins.toJSON m.scale}
      position = [${toString m.x}, ${toString m.y}]
      workspaces = ["一", "二", "三", "四", "五", "六", "七", "八", "九"]
    '';
in
{
  xdg.configFile = cfgFiles // {
    "umbriel/config.toml".source = repoLink "config.toml";

    "umbriel/cfg/display.toml".text = ''
      # Mango xwayland_ignore_scale=1: X11 apps render at native resolution
      [general]
      xwayland_native_resolution = true

      ${lib.concatMapStringsSep "\n" outputSection osConfig.sys.monitors}
    '';
  };
}
