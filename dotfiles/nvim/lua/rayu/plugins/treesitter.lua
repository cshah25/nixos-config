local nix_path = "/run/current-system/sw/share/vim-plugins/nvim-treesitter"
local is_nixos = vim.fn.isdirectory(nix_path) == 1

return {
  "nvim-treesitter/nvim-treesitter",
  dir = is_nixos and nix_path or nil,
  name = "nvim-treesitter",
  lazy = false, 
  priority = 1000,
  config = function()
    local ok, configs = pcall(require, "nvim-treesitter.configs")
    if not ok then return end

    configs.setup({
      highlight = { enable = true },
      indent = { enable = true },
    })
    
    vim.treesitter.language.register("bash", "zsh")
  end,
}