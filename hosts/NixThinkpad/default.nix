{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
  ];

  sys = {
    desktop = {
      plasma.enable = false;
      gnome.enable = false;
      niri.enable = false;
      mango.enable = true;
      umbriel.enable = false;
    };
    monitors = [
      {
        output = "eDP-1";
        width = 1920;
        height = 1200;
        refresh = 60.003;
        x = 0;
        y = 1080;
      }
      {
        output = "HDMI-A-1";
        width = 1920;
        height = 1080;
        refresh = 60;
        x = 0;
        y = 0;
      }
    ];
    boot.theme.resolution = "1920x1200"; # eDP-1 panel
    gaming.enable = true;
    virtualisation.enable = true;
    apps.enable = true;
    office.enable = true;
    development.enable = true;
    services = {
      remote.enable = true;
      tailscale.enable = true;
      fwupd.enable = true;
      displaylink.enable = false;
      rgb.enable = false;
      ollama.enable = false;
      onedrive.enable = false;
      nextcloud-mount.enable = false;
      printing.enable = true;
    };
  };

  system.stateVersion = "25.11";

  # Ryzen 7 250 is Zen 4 (Hawk Point); EEVDF is CachyOS's general-purpose default
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-zen4;

  systemd.services.NetworkManager-wait-online.enable = false;

  # Install Limine at the UEFI fallback path (EFI/BOOT/BOOTX64.EFI) instead of relying on
  # a firmware boot entry, so this drive boots when moved between the Dell and the ThinkPad
  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.limine.efiInstallAsRemovable = true;

  # The E14's mic-mute LED stays lit even when the mic is unmuted
  systemd.services.disable-mute = {
    description = "Disable Mute LED";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "disable-micmute-led" ''
        echo 0 > /sys/class/leds/platform::micmute/brightness
      '';
      RemainAfterExit = true;
    };
  };
  # Turn the keyboard backlight off after 30s without input and restore the previous level on activity.
  # swayidle honours idle inhibitors, so it stays lit while wayland-pipewire-idle-inhibit holds one (audio playing)
  systemd.user.services.kbd-backlight-idle =
    let
      kbd = "${pkgs.brightnessctl}/bin/brightnessctl --quiet --device=tpacpi::kbd_backlight";
    in
    {
      description = "Dim keyboard backlight when idle";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.swayidle}/bin/swayidle -w timeout 30 '${kbd} --save set 0' resume '${kbd} --restore'";
        Restart = "on-failure";
      };
    };

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/705be8ac-6fb3-4858-b83d-6a6e92b1c9d2";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };

  hardware.graphics.enable = true;
}
