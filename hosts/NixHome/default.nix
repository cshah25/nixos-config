{ inputs, ... }: 

{
  imports = [
    ./hardware-configuration.nix
    (import "${inputs.nixos-hardware}/common/cpu/intel")
    (import "${inputs.nixos-hardware}/common/gpu/amd")
    (import "${inputs.nixos-hardware}/common/pc/ssd")
  ];

  networking.hostName = "NixHome";

  sys = {
    desktop = {
      plasma.enable = false;
      gnome.enable = true;
      niri.enable = false;
      hyprland.enable = false;
    };
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
      rgb.enable = true;
      ollama.enable = true;
    };
  };
  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  networking = {
    useDHCP = false;

    firewall = {
      enable = true;
      trustedInterfaces = [ "br0" "br+-" "virbr0" "docker0" ];
      allowedUDPPorts = [ 9 ]; # Wake-on-LAN
    };

    nat = {
      enable = true;
      internalIPs = [ "10.0.0.0/24" ];
      externalInterface = "enp8s0f1";
    };

    interfaces.enp8s0f1 = {
      useDHCP = true;
      wakeOnLan.enable = true;
    };

    bridges.br0 = {
      interfaces = [ "enp8s0f0" "enp7s0" ];
    };

    interfaces.br0.ipv4.addresses = [{
      address = "10.0.0.1";
      prefixLength = 24;
    }];
  };

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "br0";
      bind-interfaces = true; # Ensures dnsmasq listens strictly on br0
      dhcp-range = [ "10.0.0.10,10.0.0.100,12h" ];
      dhcp-option = [
        "option:router,10.0.0.1"
        "option:dns-server,1.1.1.1,8.8.8.8"
      ];
    };
  };
  # Fixed capital 'X' to lowercase 'x' on systemd option
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/1456bb2e-df41-479f-acae-868420c1bc3a";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=5s" ];
  };

  fileSystems."/mnt/storage2" = {
    device = "/dev/disk/by-uuid/4b609e47-bd17-41a3-b601-d76fbfe4c9fe";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  hardware.graphics.enable = true;
}
