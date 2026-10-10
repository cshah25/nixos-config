{
  description = "Multi-host NixOS and Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";
    
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Not following nixpkgs: kapsule still references openssl_3, removed from unstable
    kapsule.url = "github:cshah25/kapsule";
    mangowm = {
      url = "github:mangowm/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    pkgs-stable = import nixpkgs-stable {
      inherit system;
      config.allowUnfree = true;
    };

    mkHost = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs pkgs-stable hostname; };
      modules = [
        ./modules/system
        ./modules/home-manager
        ./hosts/${hostname}
        { networking.hostName = hostname; }
      ];
    };

    # Standalone Home Manager for non-NixOS hosts (CachyOS)
    mkHome = username: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs pkgs-stable username;
        hostname = "cachyos";
        osConfig = {
          sys = {
            apps.enable = true;
            development.enable = true;
            office.enable = true;
            gaming.enable = false;
          };
        };
      };
      modules = [
        ./users/rayu/cachyos.nix
      ];
    };
  in
  {
    nixosConfigurations = nixpkgs.lib.genAttrs [
      "NixHome"       # Desktop
      "NixPrecision"  # Laptop
      "NixThinkpad"   # Thinkpad
    ] mkHost // {
      iso = nixpkgs.lib.nixosSystem {
        inherit system;
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
              nano
            ];

            networking.networkmanager.enable = true;
          })
        ];
      };
    };

    homeConfigurations = {
      "cachy@cachyos" = mkHome "cachy";
      "rayu@cachyos" = mkHome "rayu";

      "cachy" = self.homeConfigurations."cachy@cachyos";
      "rayu" = self.homeConfigurations."rayu@cachyos";
    };

    formatter.${system} = pkgs.nixfmt-rfc-style;
  };
}
