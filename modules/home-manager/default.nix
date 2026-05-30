{ config, pkgs, inputs, hostname, pkgs-stable, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs hostname pkgs-stable; };
    
    # Points to your user configuration folder
    users.rayu = import ../../users/rayu; 
  };
}
