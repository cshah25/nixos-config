{
  config,
  lib,
  pkgs,
  osConfig,
  flakeDir,
  ...
}:

let
  pond = osConfig.sys.desktop.shell == "pond";

  autostartScript = pkgs.writeShellScript "mango-autostart" ''
    # ─── Mango WM Autostart Script ───

    # 1. Propagate Wayland and Desktop environment to systemd & dbus
    ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP DISPLAY
    ${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_DESKTOP DISPLAY

    # 2. Reset failed user units from prior sessions and start session target
    ${pkgs.systemd}/bin/systemctl --user reset-failed
    ${pkgs.systemd}/bin/systemctl --user start mango-session.target

    # 3. Ensure portal services are restarted with new environment
    ${pkgs.systemd}/bin/systemctl --user restart xdg-desktop-portal-wlr xdg-desktop-portal-gtk xdg-desktop-portal

    # 4. Desktop shell (vicinae, Pond's launcher, starts with the session target)
    ${if pond then "pond-shell" else "noctalia"} &

    # 5. Wayland pipewire idle inhibitor
    wayland-pipewire-idle-inhibit &

    # 6. Equibop (Discord Client) after portals are initialized
    (sleep 3 && equibop) &

    (nextcloud --background) &
  '';

  # Shell-specific binds, sourced after cfg/bind.conf
  shellBinds =
    if pond then
      ''
        # ─── Pond Shell ───
        bind=SUPER+CTRL,Return,spawn,vicinae toggle
        bind=SUPER,V,spawn,vicinae vicinae://launch/clipboard/history?toggle=true
        bind=SUPER+ALT,L,spawn,pond-lock
        bind=SUPER,Escape,spawn,pond-lock
        bind=SUPER+SHIFT,Q,spawn,pond-msg settings toggle
        bind=CTRL+ALT,Delete,spawn,pond-msg settings toggle
        bind=SUPER,grave,spawn,pond-msg sidebar toggle

        # ─── Audio, Media & Brightness (DDC on external monitors) ───
        bind=NONE,XF86AudioRaiseVolume,spawn,pond-msg volume increase
        bind=NONE,XF86AudioLowerVolume,spawn,pond-msg volume decrease
        bind=NONE,XF86AudioMute,spawn,pond-msg volume muteOutput
        bind=NONE,XF86AudioMicMute,spawn,pond-msg volume muteInput
        bind=NONE,XF86MonBrightnessDown,spawn,pond-msg brightness decrease
        bind=NONE,XF86MonBrightnessUp,spawn,pond-msg brightness increase
        bind=NONE,XF86AudioPlay,spawn,pond-msg media playPause
        bind=NONE,XF86AudioNext,spawn,pond-msg media next
        bind=NONE,XF86AudioPrev,spawn,pond-msg media previous

        # ─── Screenshots ───
        bind=SUPER+SHIFT,1,spawn,pond-screenshot region
        bind=SUPER+SHIFT,2,spawn,pond-screenshot screen
        bind=SUPER+SHIFT,3,spawn,pond-screenshot screen
        bind=SUPER+SHIFT,4,spawn,pond-screenshot region
      ''
    else
      ''
        # ─── Noctalia Shell ───
        bind=SUPER+CTRL,Return,spawn,noctalia msg panel-toggle launcher
        bind=SUPER+ALT,L,spawn,noctalia msg session lock
        bind=SUPER,Escape,spawn,noctalia msg session lock
        bind=SUPER+SHIFT,Q,spawn,noctalia msg panel-toggle control-center
        bind=CTRL+ALT,Delete,spawn,noctalia msg panel-toggle control-center

        # ─── Audio & Media Controls (Noctalia IPC & brightnessctl/playerctl) ───
        bind=NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up
        bind=NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down
        bind=NONE,XF86AudioMute,spawn,noctalia msg volume-mute
        bind=NONE,XF86AudioMicMute,spawn,noctalia msg mic-mute
        bind=NONE,XF86MonBrightnessDown,spawn,brightnessctl s 10%-
        bind=NONE,XF86MonBrightnessUp,spawn,brightnessctl s +10%
        bind=NONE,XF86AudioPlay,spawn,playerctl play-pause
        bind=NONE,XF86AudioNext,spawn,playerctl next
        bind=NONE,XF86AudioPrev,spawn,playerctl previous

        # ─── Screenshots ───
        bind=SUPER+SHIFT,1,spawn,noctalia msg screenshot-region
        bind=SUPER+SHIFT,2,spawn,noctalia msg screenshot-fullscreen
        bind=SUPER+SHIFT,3,spawn,noctalia msg screenshot-fullscreen all
        bind=SUPER+SHIFT,4,spawn,noctalia msg screenshot-fullscreen pick
      '';

  # Static config files link straight into the repo, so edits apply without a rebuild
  # (adding or removing a file in dotfiles/mango/cfg still needs one)
  repoLink =
    path: config.lib.file.mkOutOfStoreSymlink "${flakeDir}/users/rayu/dotfiles/mango/${path}";
  cfgFiles = lib.mapAttrs' (
    name: _: lib.nameValuePair "mango/cfg/${name}" { source = repoLink "cfg/${name}"; }
  ) (builtins.readDir ./dotfiles/mango/cfg);

  # Rendered from sys.monitors in the host config
  monitorRule =
    m:
    "monitor_rule="
    + lib.concatStringsSep "," (
      lib.optional (m.output != null) "name:${m.output}"
      ++ lib.optional (m.make != null) "make:${m.make}"
      ++ lib.optional (m.model != null) "model:${m.model}"
      ++ lib.optional (m.serial != null) "serial:${m.serial}"
      ++ [
        "width:${toString m.width}"
        "height:${toString m.height}"
        "refresh:${builtins.toJSON m.refresh}"
        "scale:${builtins.toJSON m.scale}"
        "x:${toString m.x}"
        "y:${toString m.y}"
      ]
    );
in
{
  xdg.configFile = cfgFiles // {
    "mango/config.conf".source = repoLink "config.conf";
    "mango/cfg/autostart.conf".text = ''
      # ─── Startup Applications ───
      exec_once=${autostartScript}
    '';

    "mango/cfg/shell.conf".text = shellBinds;

    "mango/cfg/display.conf".text = ''
      xwayland_ignore_scale=1
      ${lib.concatMapStringsSep "\n" monitorRule osConfig.sys.monitors}
    '';
  };
}
