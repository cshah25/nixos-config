{ config, pkgs, hostname, ... }:

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

    "niri/cfg/display.kdl".text = if hostname == "NixHome" then ''
      output "DP-3" {
          mode "3840x2160@144.001"
          scale 1.5
          position x=2560 y=0
      }

      output "DP-2" {
          mode "3840x2160@60"
          scale 1.5
          position x=0 y=0
      }
    '' else if hostname == "NixPrecision" then ''
      output "eDP-1" {
          mode "1920x1200@59.950"
          scale 1
          position x=0 y=1080 
      }
    '' else "";
  };
}
