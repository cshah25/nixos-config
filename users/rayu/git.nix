{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Chirayu Shah";
    userEmail = "chirayushah61@gmail.com";
    extraConfig = {
      core.editor = "nvim";
      pull.rebase = false;
    };
  };
}
