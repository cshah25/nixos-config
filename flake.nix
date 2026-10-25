{
  description = "Multi-host NixOS and Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-26.05";

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    # No nixpkgs follows: the kernel patches are pinned to this flake's own nixpkgs
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kapsule = {
      url = "github:cshah25/kapsule";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      username = "rayu";
      flakeDir = "/home/${username}/nixos-config";

      mkHost =
        hostname:
        nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs username flakeDir; };
          modules = [
            ./modules/system
            ./modules/home-manager
            ./hosts/${hostname}
            { networking.hostName = hostname; }
          ];
        };

      hosts = [
        "NixHome" # Desktop
        "NixThinkpad" # Thinkpad
        # "NixPrecision" # Laptop; re-add once its hardware-configuration.nix is committed
      ];
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost // {
        iso = nixpkgs.lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
            ({ pkgs, ... }: {
              nixpkgs.hostPlatform = system;
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];

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

      # `nix flake check` builds every host, catching a broken one before you switch to it
      checks.${system} = nixpkgs.lib.genAttrs hosts (
        h: self.nixosConfigurations.${h}.config.system.build.toplevel
      );

      # `nix fmt` formats every .nix file in the repo
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
    };
}
