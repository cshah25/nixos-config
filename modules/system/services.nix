{ config, lib, ... }:

{
  options.sys.services = {
    ssh.enable = lib.mkEnableOption "OpenSSH";
    tailscale.enable = lib.mkEnableOption "Tailscale";
  };

  config = lib.mkMerge [
    (lib.mkIf config.sys.services.ssh.enable {
      services.openssh.enable = true;
    })
    (lib.mkIf config.sys.services.tailscale.enable {
      services.tailscale.enable = true;
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
      networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
    })
    {
      services.flatpak.enable = true;
      networking.firewall.enable = true;
      networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
    }
  ];
}
