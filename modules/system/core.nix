{
  networking.networkmanager.enable = true;
  
  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "root" "@wheel" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "25.11"; 
}
