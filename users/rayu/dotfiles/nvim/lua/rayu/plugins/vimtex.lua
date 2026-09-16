return {
  "lervag/vimtex",
  lazy = false, -- VimTeX handles its own lazy loading
  init = function()
    -- VimTeX configuration must be set in `init` (before plugin loads) using global variables
    
    -- Set the PDF viewer to Zathura
    -- This provides live updating and forward/backward search (syncing code with PDF)
    vim.g.vimtex_view_method = "zathura"
    
    -- Use latexmk for continuous compilation (it compiles on save automatically)
    vim.g.vimtex_compiler_method = "latexmk"
    
    -- Do not open the quickfix menu automatically if there are warning messages (only errors)
    vim.g.vimtex_quickfix_open_on_warning = 0
  end,
}
