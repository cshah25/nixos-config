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
    };
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
