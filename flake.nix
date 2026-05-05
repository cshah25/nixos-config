{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      # Desktop Configuration
      NixHome = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
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
              options = [ "defaults" "nofail" "X-systemd.device-timeout=5s" ];
            };
            fileSystems."/mnt/storage2" = {
              device = "/dev/disk/by-uuid/7b49a9b6-3126-4a4e-9ef1-23f3223d377d";
              fsType = "ext4";
              options = [ "defaults" "nofail" "X-systemd.device-timeout=5s" ];
            };
          }
        ];
      };

      # Laptop Configuration
      NixPrecision = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./laptop.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rayu = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
          {
            fileSystems."/mnt/storage" = {
              device = "/dev/disk/by-uuid/103c2982-e6b3-484e-bc22-3a32504cbd63";
              fsType = "ext4";
              options = [ "defaults" "nofail" "X-systemd.device-timeout=5s"];
            };
          }
        ];
      };
    };
  };
}
