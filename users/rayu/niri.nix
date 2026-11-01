{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  pond = osConfig.sys.desktop.shell == "pond";

  # Rendered from sys.monitors in the host config
  outputBlock = m: ''
    output "${if m.output != null then m.output else "${m.make} ${m.model} ${m.serial}"}" {
        mode "${toString m.width}x${toString m.height}@${builtins.toJSON m.refresh}"
        scale ${builtins.toJSON m.scale}
        position x=${toString m.x} y=${toString m.y}
    }
  '';

  noctaliaShell = ''
    spawn-sh-at-startup "noctalia"

    binds {
        MOD+CTRL+RETURN         hotkey-overlay-title="Open App Launcher: noctalia launcher" { spawn-sh "noctalia msg panel-toggle launcher"; }
        MOD+L                   hotkey-overlay-title="Lock Screen: noctalia lock" { spawn-sh "noctalia msg session lock"; }
        MOD+SHIFT+Q             hotkey-overlay-title="Session Menu" { spawn-sh "noctalia msg panel-toggle control-center"; }
        CTRL+ALT+DELETE         hotkey-overlay-title="Session Menu" { spawn-sh "noctalia msg panel-toggle control-center"; }

        XF86AUDIORAISEVOLUME    allow-when-locked=true { spawn-sh "noctalia msg volume-up"; }
        XF86AUDIOLOWERVOLUME    allow-when-locked=true { spawn-sh "noctalia msg volume-down"; }
        XF86MonBrightnessDown   allow-when-locked=true { spawn-sh "brightnessctl s 10%-"; }
        XF86MonBrightnessUp     allow-when-locked=true { spawn-sh "brightnessctl s +10%"; }
        XF86AUDIOMUTE           allow-when-locked=true { spawn-sh "noctalia msg volume-mute"; }
        XF86AUDIOMICMUTE        allow-when-locked=true { spawn-sh "noctalia msg mic-mute"; }
        XF86PowerOff            allow-when-locked=true { spawn-sh "noctalia msg session lock"; }
        XF86AudioPlay           allow-when-locked=true { spawn-sh "playerctl play-pause"; }
    }
  '';

  # Pond's niri integration, from pond-interface's config/niri/shell/config.kdl
  pondShell = ''
    spawn-sh-at-startup "pond-shell"

    binds {
        MOD+CTRL+RETURN         repeat=false hotkey-overlay-title="Open Launcher" { spawn "vicinae" "toggle"; }
        MOD+V                   repeat=false hotkey-overlay-title="Clipboard History" { spawn "vicinae" "vicinae://launch/clipboard/history?toggle=true"; }
        MOD+L                   hotkey-overlay-title="Lock Screen" { spawn "pond-lock"; }
        MOD+SHIFT+Q             hotkey-overlay-title="Settings & Power" { spawn "pond-msg" "settings" "toggle"; }
        CTRL+ALT+DELETE         hotkey-overlay-title="Settings & Power" { spawn "pond-msg" "settings" "toggle"; }
        MOD+GRAVE               hotkey-overlay-title="Toggle Sidebar" { spawn "pond-msg" "sidebar" "toggle"; }

        XF86AudioRaiseVolume    allow-when-locked=true { spawn "pond-msg" "volume" "increase"; }
        XF86AudioLowerVolume    allow-when-locked=true { spawn "pond-msg" "volume" "decrease"; }
        XF86AudioMute           allow-when-locked=true repeat=false { spawn "pond-msg" "volume" "muteOutput"; }
        XF86AudioMicMute        allow-when-locked=true repeat=false { spawn "pond-msg" "volume" "muteInput"; }
        XF86AudioNext           allow-when-locked=true repeat=false { spawn "pond-msg" "media" "next"; }
        XF86AudioPrev           allow-when-locked=true repeat=false { spawn "pond-msg" "media" "previous"; }
        XF86AudioPlay           allow-when-locked=true repeat=false { spawn "pond-msg" "media" "playPause"; }
        XF86MonBrightnessUp     allow-when-locked=true { spawn "pond-msg" "brightness" "increase"; }
        XF86MonBrightnessDown   allow-when-locked=true { spawn "pond-msg" "brightness" "decrease"; }
        XF86PowerOff            allow-when-locked=true { spawn "pond-lock"; }
    }

    // Keep sidebar drags from panning the tiling view at a screen edge
    gestures {
        dnd-edge-view-scroll {
            max-speed 0
        }
    }

    // Keep the wallpaper stationary behind workspaces and the overview
    layer-rule {
        match namespace="^pond-wallpaper$"
        place-within-backdrop true
    }

    // Blur behind the sidebar, OSDs and launcher
    layer-rule {
        match namespace="^pond-((sidebar|volume|brightness|keyboard)$|calendar-)"
        match namespace="^vicinae$"
        background-effect {
            xray false
        }
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

    "niri/cfg/shell.kdl".text = if pond then pondShell else noctaliaShell;

    "niri/cfg/display.kdl".text = lib.concatMapStringsSep "\n" outputBlock osConfig.sys.monitors;
  };
}
