{
  inputs,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-amd
    inputs.nixos-hardware.nixosModules.common-pc-ssd
  ];

  sys = {
    desktop = {
      plasma.enable = false;
      gnome.enable = false;
      niri.enable = false;
      mango.enable = true;
      umbriel.enable = false;
      shell = "pond";
    };
    monitors = [
      {
        make = "ASUSTek COMPUTER INC";
        model = "ASUS VG289";
        serial = "R9LMTF128641";
        width = 3840;
        height = 2160;
        refresh = 60;
        scale = 2;
        x = 0;
        y = 0;
      }
      {
        make = "Microstep";
        model = "MAG 275UD E14";
        serial = "CE8M435A00519";
        width = 3840;
        height = 2160;
        refresh = 60;
        gamingRefresh = 144.001007;
        scale = 2;
        x = 1920;
        y = 0;
      }
    ];
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
      onedrive.enable = true;
      printing.enable = true;
    };
    hardware.ddc.enable = true;
  };

  system.stateVersion = "25.11";

  # BORE for gaming responsiveness; i7-12700K has AVX-512 fused off, so v3 is the highest tier
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;

  # gfx1101 isn't on ROCm's official support list
  services.ollama.rocmOverrideGfx = "11.0.1";

  # Magic packets are handled by the NIC, so no firewall port is needed
  networking.interfaces.enp7s0.wakeOnLan.enable = true;

  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/1456bb2e-df41-479f-acae-868420c1bc3a";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };

  fileSystems."/mnt/storage2" = {
    device = "/dev/disk/by-uuid/4b609e47-bd17-41a3-b601-d76fbfe4c9fe";
    fsType = "ext4";
    options = [
      "defaults"
      "nofail"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
    ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  # AMD GPU stuff
  hardware.graphics.enable = true;

  # Under "auto", dual 4K60 keeps VRAM at 772MHz (~80°C) on the desktop; "low" settles at 456MHz
  # but also floors the core clock, so LACT switches to "auto" whenever a game is running.
  # Fan control stays disabled: LACT then resets the fans to the firmware's own curve, which
  # watches junction temperature (a custom edge-based curve once let junction hit 110°C).
  services.lact = {
    enable = true;
    settings =
      let
        gpu = "1002:747E-1002:0E37-0000:03:00.0"; # RX 7800 XT
      in
      {
        version = 7;
        daemon = {
          log_level = "info";
          admin_group = "wheel";
          disable_clocks_cleanup = false;
        };
        apply_settings_timer = 5;
        gpus.${gpu} = {
          fan_control_enabled = false;
          performance_level = "low";
        };
        profiles.gaming = {
          gpus.${gpu} = {
            fan_control_enabled = false;
            performance_level = "auto";
          };
          # Steam wraps every game (native or Proton) in `reaper SteamLaunch`;
          # Heroic's Wine/Proton games run a wineserver.
          rule = {
            type = "or";
            filter = [
              {
                type = "process";
                filter = {
                  name = "reaper";
                  args = "SteamLaunch";
                };
              }
              {
                type = "process";
                filter.name = "wineserver";
              }
            ];
          };
        };
        current_profile = null;
        auto_switch_profiles = true;
      };
  };
}
