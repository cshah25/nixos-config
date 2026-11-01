{
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  desktop = osConfig.sys.desktop;
in
{
  config = lib.mkIf ((desktop.niri.enable || desktop.mango.enable) && desktop.shell == "pond") {
    home.packages = [ pkgs.pond ];

    # Launcher behind Pond's search card, clipboard history and empty-workspace prompt
    programs.vicinae = {
      enable = true;
      systemd.enable = true;

      themes.pond = {
        meta = {
          version = 1;
          name = "Pond";
          description = "Dark, quiet and lilac, to match the Pond shell";
          variant = "dark";
          inherits = "vicinae-dark";
        };
        colors = {
          core = {
            background = "#181818";
            foreground = "#FFFFFF";
            secondary_background = "#262626";
            border = "#303030";
            accent = "#CBA6F7";
          };
          main_window.border = "#303030";
          text = {
            muted = "#99FFFFFF";
            placeholder = "#33FFFFFF";
          };
          list.item.hover.background = "#262626";
        };
      };

      settings = {
        font.normal.family = "Onest";
        theme = {
          dark.name = "pond";
          light.name = "pond";
        };
        launcher_window = {
          opacity = 0.85;
          rounding = 24;
          # Just the search bar until you type, like Pond's card
          compact_mode.enabled = true;
          client_side_decorations = {
            enabled = true;
            border_width = 1;
          };
        };
      };
    };
  };
}
