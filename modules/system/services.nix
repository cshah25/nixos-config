{ config, lib, pkgs, ... }:

{
  options.sys.services = {
    ssh.enable = lib.mkEnableOption "OpenSSH";
    tailscale.enable = lib.mkEnableOption "Tailscale";
    fwupd.enable = lib.mkEnableOption "fwupd";
    displaylink.enable = lib.mkEnableOption "DisplayLink";
  };

  config = lib.mkMerge [
    {
      security.pam.services.sddm.enableKwallet = true;
    }

    (lib.mkIf config.sys.services.ssh.enable {
      services.openssh.enable = true;
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
    {
      services.flatpak.enable = true;
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    }
  ];
}
