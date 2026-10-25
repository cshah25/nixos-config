{ inputs, flakeDir, ... }:

{
  networking.networkmanager.enable = true;

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://cache.lantian.pub/lantian" # nix-cachyos-kernel
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
    ];
  };

  nixpkgs.config.allowUnfree = true;

  # pkgs.stable: nixos-26.05 fallback for packages broken on unstable
  nixpkgs.overlays = [
    (final: prev: {
      stable = import inputs.nixpkgs-stable {
        inherit (final.stdenv.hostPlatform) system;
        config.allowUnfree = true;
      };
    })
  ];
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  # nh: nicer rebuilds (`nh os switch`) plus weekly cleanup of old generations
  programs.nh = {
    enable = true;
    flake = flakeDir;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
  };
}
