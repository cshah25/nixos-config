{ config, lib, pkgs, osConfig, ... }:

let
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

    # 4. Noctalia desktop shell
    noctalia &

    # 5. Wayland pipewire idle inhibitor
    wayland-pipewire-idle-inhibit &

    # 6. Equibop (Discord Client) after portals are initialized
    (sleep 3 && equibop) &

    (nextcloud --background) &
  '';

  # Rendered from sys.monitors in the host config
  monitorRule = m: "monitor_rule=" + lib.concatStringsSep "," (
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
  xdg.configFile = {
    "mango/config.conf".source = ./dotfiles/mango/config.conf;
    "mango/cfg/env.conf".source = ./dotfiles/mango/cfg/env.conf;
    "mango/cfg/autostart.conf".text = ''
      # ─── Startup Applications ───
      exec_once=${autostartScript}
    '';
    "mango/cfg/input.conf".source = ./dotfiles/mango/cfg/input.conf;
    "mango/cfg/layout.conf".source = ./dotfiles/mango/cfg/layout.conf;
    "mango/cfg/rules.conf".source = ./dotfiles/mango/cfg/rules.conf;
    "mango/cfg/bind.conf".source = ./dotfiles/mango/cfg/bind.conf;

    "mango/cfg/display.conf".text = ''
      xwayland_ignore_scale=1
      ${lib.concatMapStringsSep "\n" monitorRule osConfig.sys.monitors}
    '';
  };
}
