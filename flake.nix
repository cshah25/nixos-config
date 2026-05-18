{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, ... }@inputs: 
  let
    system = "x86_64-linux";
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in 
  {
    nixosConfigurations = {

      # Desktop Configuration
      NixHome = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-stable; };
        modules = [
          ./modules/system
          ./modules/home-manager
          ./hosts/NixHome
        ];
      };

      # Laptop Configuration
      NixPrecision = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-stable; };
        modules = [
          ./modules/system
          ./modules/home-manager
          ./hosts/NixPrecision
        ];
      };
    };
  };
}
