{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Add Lanzaboote
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0"; # Check for the latest release
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, ... }@inputs: {
    nixosConfigurations = {
      # Desktop Configuration
      NixHome = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote # Add Lanzaboote module
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rayu = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
          {
            fileSystems."/mnt/storage" = {
              device = "/dev/disk/by-uuid/1456bb2e-df41-479f-acae-868420c1bc3a";
              fsType = "ext4";
            };
          }
        ];
      };

      # Laptop Configuration
      NixPrecision = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote # Add Lanzaboote module
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rayu = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
    };
  };
}
