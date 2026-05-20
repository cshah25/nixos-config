{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Chirayu Shah";
        email = "chirayushah61@gmail.com";
      };
      core.editor = "nvim";
      pull.rebase = false;
    };
  };
}
