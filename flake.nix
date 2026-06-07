{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    kapsule.url = "github:cshah25/kapsule";
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, kapsule, home-manager, ... }@inputs: 
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
        specialArgs = { inherit inputs pkgs-stable; hostname = "NixHome"; };
        modules = [
          ./modules/system
          ./modules/home-manager
          ./hosts/NixHome
        ];
      };

      # Laptop Configuration
      NixPrecision = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-stable; hostname = "NixPrecision"; };
        modules = [
          ./modules/system
          ./modules/home-manager
          ./hosts/NixPrecision
        ];
      };

      # Thinkpad Configuration
      NixThinkpad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-stable; hostname = "NixThinkpad"; };
        modules = [
          ./modules/system
          ./modules/home-manager
          ./hosts/NixThinkpad
        ];
      };
      iso = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs pkgs-stable; hostname = "NixISO"; };
        modules = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
          ({ pkgs, ... }: {
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            
            environment.systemPackages = with pkgs; [
              neovim
              git
              tmux
              htop
              curl
            ];

            networking.networkmanager.enable = true;
          })
        ];
      };
    };
  };
}
