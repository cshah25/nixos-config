{
  config,
  lib,
  pkgs,
  inputs,
  username,
  ...
}:

let
  cfg = config.sys.desktop;
  # Standalone Wayland compositors paired with the Noctalia shell
  tiling = cfg.niri.enable || cfg.mango.enable || cfg.umbriel.enable;
  # Standalone compositors log in through a greeter of their own, not a full DE's display manager
  ownGreeter = tiling && !cfg.plasma.enable && !cfg.gnome.enable;
  pondGreeter = ownGreeter && cfg.shell == "pond";

  # Pond's greeter is an SDDM theme shown inside a bare niri, as on Pond itself
  greeterNiriConfig = pkgs.writeText "pond-greeter-niri.kdl" ''
    prefer-no-csd
    hotkey-overlay { skip-at-startup; }
    animations { off; }

    input {
        keyboard {
            xkb {
                layout "${config.services.xserver.xkb.layout}"
                variant "${config.services.xserver.xkb.variant}"
            }
        }
    }

    cursor {
        xcursor-theme "Bibata-Modern-Ice"
        xcursor-size ${toString cfg.cursorSize}
    }

    window-rule {
        match app-id="^sddm-greeter"
        open-fullscreen true
    }

    ${lib.concatMapStringsSep "\n" (m: ''
      output "${if m.output != null then m.output else "${m.make} ${m.model} ${m.serial}"}" {
          mode "${toString m.width}x${toString m.height}@${builtins.toJSON m.refresh}"
          scale ${builtins.toJSON m.scale}
          position x=${toString m.x} y=${toString m.y}
      }
    '') config.sys.monitors}
  '';
in
{
  imports = [
    inputs.mangowm.nixosModules.mango
    inputs.umbriel.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
  ];

  options.sys.desktop = {
    plasma.enable = lib.mkEnableOption "KDE Plasma";
    gnome.enable = lib.mkEnableOption "GNOME";
    niri.enable = lib.mkEnableOption "Niri";
    mango.enable = lib.mkEnableOption "Mango WM";
    umbriel.enable = lib.mkEnableOption "Umbriel";
    shell = lib.mkOption {
      type = lib.types.enum [
        "noctalia"
        "pond"
      ];
      default = "noctalia";
      description = "Desktop shell for Niri and Mango (Umbriel always uses Noctalia).";
    };
    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Cursor size for the greeter and Niri.";
    };
  };

  config = lib.mkIf (cfg.plasma.enable || cfg.gnome.enable || tiling) {
    nixpkgs.overlays = [
      (final: _: {
        pond = final.callPackage ../../pkgs/pond { };
        pond-boot = final.callPackage ../../pkgs/pond/boot.nix { };
      })
    ];

    # Pond ships its UI fonts; its lockscreen and launcher run from the user session
    fonts.packages = lib.mkIf (tiling && cfg.shell == "pond") [
      pkgs.pond
      pkgs.ibm-plex
    ];

    # X server only for the full DEs; standalone Wayland compositors run XWayland themselves
    services.xserver.enable = cfg.plasma.enable || cfg.gnome.enable;

    # Both default to services.xserver.enable, but Wayland sessions need them too
    services.libinput.enable = true;
    gtk.iconCache.enable = true;

    # Use SDDM when KDE Plasma is enabled, or for Pond's greeter (below)
    services.displayManager.sddm.enable = lib.mkDefault (cfg.plasma.enable || pondGreeter);
    services.desktopManager.plasma6.enable = cfg.plasma.enable;

    # Use GDM when GNOME is enabled
    services.displayManager.gdm.enable = lib.mkDefault (cfg.gnome.enable && !cfg.plasma.enable);
    services.desktopManager.gnome.enable = cfg.gnome.enable;

    # Plasma and GNOME each set their own SSH askpass; prefer GNOME's since gnome-keyring is always on
    programs.ssh.askPassword = lib.mkIf (cfg.plasma.enable && cfg.gnome.enable) (
      lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass"
    );

    # Pond's login screen for standalone compositors when Pond is the shell; it lists every
    # installed session (mango, niri, ...) in its compositor picker
    services.displayManager.sddm.theme = lib.mkIf pondGreeter "pond";
    services.displayManager.sddm.wayland = lib.mkIf pondGreeter {
      enable = true;
      compositorCommand = "${pkgs.coreutils}/bin/env XCURSOR_PATH=${pkgs.bibata-cursors}/share/icons ${lib.getExe pkgs.niri} --config ${greeterNiriConfig}";
    };
    # Pond.System and Pond.Daylight QML modules, and the Qt modules the theme draws with
    services.displayManager.sddm.extraPackages = lib.mkIf pondGreeter [
      pkgs.pond
      pkgs.qt6.qtsvg
    ];
    services.displayManager.sddm.settings.Theme = lib.mkIf pondGreeter {
      CursorTheme = "Bibata-Modern-Ice";
      CursorSize = cfg.cursorSize;
    };
    environment.systemPackages = lib.mkIf pondGreeter [
      pkgs.pond
      pkgs.bibata-cursors
    ];

    # Use Noctalia Greeter for standalone compositors (Niri, Mango, Umbriel) otherwise
    services.displayManager.noctalia-greeter = {
      enable = lib.mkDefault (ownGreeter && !pondGreeter);
      greeter-args = lib.mkDefault "";
      passwordless-sync-users = [ username ];
      settings = {
        cursor = {
          theme = "Bibata-Modern-Ice";
          size = cfg.cursorSize;
          path = "${pkgs.bibata-cursors}/share/icons";
        };
        keyboard = {
          layout = "us";
        };
      };
    };

    programs.niri.enable = cfg.niri.enable;
    services.upower.enable = lib.mkDefault tiling;

    programs.mango.enable = cfg.mango.enable;
    # Also installs xdg-desktop-portal-umbriel for screen sharing and registers the greeter session
    programs.umbriel.enable = cfg.umbriel.enable;

    # Enable system-level Thunar and Xfconf for tiling WMs (provides D-Bus services and settings backend)
    programs.thunar = lib.mkIf tiling {
      enable = true;
      plugins = [
        pkgs.thunar-archive-plugin
        pkgs.thunar-volman
      ];
    };
    programs.xfconf.enable = lib.mkDefault tiling;

    # Configure xdg portal for Mango WM screen sharing & desktop integration
    xdg.portal = lib.mkIf cfg.mango.enable {
      enable = true;
      wlr = {
        enable = true;
        settings = {
          screencast = {
            chooser_type = "simple";
            chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
          };
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      config = {
        mango = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "wlr" ];
        };
      };
    };

    systemd.user.targets.mango-session = lib.mkIf cfg.mango.enable {
      description = "Mango WM Session";
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
