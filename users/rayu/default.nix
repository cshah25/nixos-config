{
  config,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ./packages.nix
    ./theme.nix
    ./niri.nix
    ./mango.nix
    ./umbriel.nix
    ./mime.nix
    ./thunar.nix
    ./services.nix
    ./zsh.nix
    ./git.nix
    ./nvim.nix
    ./alacritty.nix
    ./apps.nix
    ./zen.nix
    ./dev.nix
    ./office.nix
    ./gaming.nix
  ];
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
}
