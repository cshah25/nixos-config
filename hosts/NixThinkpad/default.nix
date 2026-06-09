{inputs, ...}:

{
  imports = [
    ./hardware-configuration.nix

    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
  ];

  networking.hostName = "NixThinkpad";

  sys = {
    desktop = {
      plasma.enable = false;
      gnome.enable = true;
      niri.enable = true;
    };
    gaming.enable = true;
    virtualisation.enable = true;
    apps.enable = true;
    office.enable = true;
    development.enable = true;
    services = {
      ssh.enable = true;
      tailscale.enable = true;
      fwupd.enable = true;
      displaylink.enable = true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.user.services.disable-mute = {
    description = "Disable Mute LED";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    
    serviceConfig = {
      ExecStart = "/home/rayu/.local/bin/disable_mute.sh";
      Restart = "on-failure";
    };
  };
}
