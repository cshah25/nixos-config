{ pkgs, ... }:
{
  users.defaultUserShell = pkgs.zsh;

  users.users.rayu = {
    isNormalUser = true;
    description = "Chirayu Shah";
    extraGroups = [ "networkmanager" "wheel" "docker" "libvirtd" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };
}
