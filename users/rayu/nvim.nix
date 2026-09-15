{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withPython3 = false;
    withRuby = false;
    extraPackages = with pkgs; [
      tree-sitter
      gcc
    ];
  };
  xdg.configFile = {
	 "nvim".source = ./dotfiles/nvim;
  };
}
