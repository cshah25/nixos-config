{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    settings = {
      user = {
        name = "Chirayu Shah";
        email = "chirayushah61@gmail.com";
      };
      core.editor = "nvim";
      pull.rebase = false;

      credential.helper = "${pkgs.gitFull}/bin/git-credential-libsecret";
    };
  };
}
