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
      gnome.enable = false;
      niri.enable = true;
      hyprland.enable = false;
    };
    gaming.enable = false;
    virtualisation.enable = true;
    apps.enable = true;
    office.enable = true;
    development.enable = true;
    services = {
      remote.enable = true;
      tailscale.enable = true;
      fwupd.enable = true;
      displaylink.enable = true;
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  systemd.services.disable-mute = {
    description = "Disable Mute LED";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "/home/rayu/.local/bin/disable_mute.sh";
      RemainAfterExit = true;
    };    
  };
}
