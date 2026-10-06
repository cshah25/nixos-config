{ config, inputs, pkgs, ... }: 

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
      gnome.enable = false;
      niri.enable = false;
      hyprland.enable = false;
      mango.enable = true;
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
      onedrive.enable = true;
      printing.enable = true;
    };
  };

  boot.supportedFilesystems = [ "fuse" ];

  networking = {
    firewall = {
      enable = true;
      allowedUDPPorts = [ 9 ]; # Wake-on-LAN
    };

    interfaces.enp7s0.wakeOnLan.enable = true;
  };
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

  # AMD GPU stuff
  hardware.graphics.enable = true;
  #environment.systemPackages = with pkgs; [ lact ];
  #systemd.packages = with pkgs; [ lact ];
  #systemd.services.lactd.wantedBy = [ "multi-user.target" ];
  hardware.amdgpu.overdrive.enable = true;
  programs.coolercontrol.enable = true;
  boot.kernelModules = [ "it87" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ it87 ];
  boot.kernelParams = [ "acpi_enforce_resources=lax" ];
}
