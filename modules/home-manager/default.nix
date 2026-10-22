{
  config,
  inputs,
  username,
  flakeDir,
  ...
}:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username flakeDir; };

    users.${username} = {
      imports = [ ../../users/rayu ];
      # Home Manager state follows the release the host was installed with
      home.stateVersion = config.system.stateVersion;
    };
  };
}
