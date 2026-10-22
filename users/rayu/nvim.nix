{
  config,
  pkgs,
  flakeDir,
  ...
}:

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
  # Home Manager owns init.lua (it adds its provider settings), so ours is appended to it
  programs.neovim.initLua = builtins.readFile ./dotfiles/nvim/init.lua;

  # lua/ is linked straight into the repo, so edits apply without a rebuild
  xdg.configFile."nvim/lua".source =
    config.lib.file.mkOutOfStoreSymlink "${flakeDir}/users/rayu/dotfiles/nvim/lua";
}
