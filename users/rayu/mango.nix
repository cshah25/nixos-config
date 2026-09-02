{ config, pkgs, hostname, ... }:

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
in
{
  xdg.configFile = {
    "mango/config.conf".source = ./dotfiles/mango/config.conf;
    "mango/cfg/env.conf".source = ./dotfiles/mango/cfg/env.conf;
    "mango/cfg/autostart.conf".text = ''
      # ─── Startup Applications ───
      exec-once=${autostartScript}
    '';
    "mango/cfg/input.conf".source = ./dotfiles/mango/cfg/input.conf;
    "mango/cfg/layout.conf".source = ./dotfiles/mango/cfg/layout.conf;
    "mango/cfg/rules.conf".source = ./dotfiles/mango/cfg/rules.conf;
    "mango/cfg/bind.conf".source = ./dotfiles/mango/cfg/bind.conf;

    "mango/cfg/display.conf".text = if hostname == "NixHome" then ''
      # NixHome dual 4K monitor configuration
      monitorrule=name:DP-3,width:3840,height:2160,refresh:144,scale:1.5,x:0,y:0
      monitorrule=name:DP-2,width:3840,height:2160,refresh:60,scale:1.5,x:2560,y:0
    '' else if hostname == "NixPrecision" then ''
      # NixPrecision Dell laptop display
      monitorrule=name:eDP-1,width:1920,height:1200,refresh:60,scale:1,x:0,y:1080
    '' else if hostname == "NixThinkpad" then ''
      # NixThinkpad Lenovo laptop display
      monitorrule=name:eDP-1,width:1920,height:1200,refresh:60,scale:1,x:0,y:1080
    '' else "";
  };
}
