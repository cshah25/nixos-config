return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ft = { "markdown" }, -- only load when opening markdown files
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {},
}
