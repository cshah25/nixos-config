{ config, lib, pkgs, ... }:

{
  options.sys.services = {
    remote.enable = lib.mkEnableOption "Remote Services";
    tailscale.enable = lib.mkEnableOption "Tailscale";
    fwupd.enable = lib.mkEnableOption "fwupd";
    displaylink.enable = lib.mkEnableOption "DisplayLink";
    rgb.enable = lib.mkEnableOption "openrgb";
    ollama.enable = lib.mkEnableOption "Ollama LLMs";
  };

  config = lib.mkMerge [
    {
      security.pam.services.sddm.enableKwallet = true;
      security.pam.services.sddm.enableGnomeKeyring = true;
      services.gnome.gnome-keyring.enable = true;
      services.resolved.enable = true;
    }

    (lib.mkIf config.sys.services.remote.enable {
      services.openssh.enable = true;
      services.sunshine = {
        enable = true;
        autoStart = true;
        capSysAdmin = true;
        openFirewall = true;
      };
    })
    (lib.mkIf config.sys.services.tailscale.enable {
      services.tailscale.enable = true;
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
      networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
    })
    (lib.mkIf config.sys.services.fwupd.enable {
      services.fwupd.enable = true;
    })
    (lib.mkIf config.sys.services.displaylink.enable {
      environment.systemPackages = [
        pkgs.displaylink
      ];
      boot = {
        extraModulePackages = [ config.boot.kernelPackages.evdi ];
        initrd.kernelModules = [ "evdi" ];
      };
      services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
      systemd.services.dlm.wantedBy = [ "multi-user.target" ];
    })
    (lib.mkIf config.sys.services.rgb.enable {
      services.hardware.openrgb = {
        enable = true;
        package = pkgs.openrgb-with-all-plugins;
      };
    })
    (lib.mkIf config.sys.services.ollama.enable {
      services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
        rocmOverrideGfx = "11.0.1";
      };
    })
    {
      services.flatpak.enable = true;
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    }
  ];
}
