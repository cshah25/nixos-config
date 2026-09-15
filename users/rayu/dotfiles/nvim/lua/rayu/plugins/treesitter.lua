return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    -- ensure these language parsers are installed
    require("nvim-treesitter").install({
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "rust",
      "cpp",
      "python",
      "c_sharp"
    })

    -- enable syntax highlighting and indentation natively
    vim.api.nvim_create_autocmd('FileType', {
      pattern = '*',
      callback = function(args)
        -- enable treesitter highlighting
        pcall(vim.treesitter.start, args.buf)
        -- enable treesitter indentation
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })

    -- Note: `incremental_selection` was removed in the nvim-treesitter main branch rewrite.

    -- use bash parser for zsh files
    vim.treesitter.language.register("bash", "zsh")
  end,
}
