{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    withPython3 = false;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      # Core Dependencies
      plenary-nvim
      nvim-web-devicons

      # UI
      {
        plugin = alpha-nvim;
        type = "lua";
        config = ''
          local alpha = require("alpha")
          local dashboard = require("alpha.themes.dashboard")

          dashboard.section.header.val = {
            "                                                     ",
            "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
            "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
            "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
            "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
            "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
            "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            "                                                     ",
          }

          dashboard.section.buttons.val = {
            dashboard.button("e", "  > New File", "<cmd>ene<CR>"),
            dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
            dashboard.button("SPC ff", "󰱼  > Find File", "<cmd>Telescope find_files<CR>"),
            dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
            dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>AutoSession restore<CR>"),
            dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
          }

          alpha.setup(dashboard.opts)
          vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
        '';
      }
      {
        plugin = bufferline-nvim;
        type = "lua";
        config = ''
          require("bufferline").setup({
            options = {
              mode = "tabs",
            },
          })
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          local lualine = require("lualine")
          local colors = {
            blue = "#65D1FF", green = "#3EFFDC", violet = "#FF61EF",
            yellow = "#FFDA7B", red = "#FF4A4A", fg = "#c3ccdc",
            bg = "#112638", inactive_bg = "#2c3043",
          }
          local my_lualine_theme = {
            normal = { a = { bg = colors.blue, fg = colors.bg, gui = "bold" }, b = { bg = colors.bg, fg = colors.fg }, c = { bg = colors.bg, fg = colors.fg } },
            insert = { a = { bg = colors.green, fg = colors.bg, gui = "bold" }, b = { bg = colors.bg, fg = colors.fg }, c = { bg = colors.bg, fg = colors.fg } },
            visual = { a = { bg = colors.violet, fg = colors.bg, gui = "bold" }, b = { bg = colors.bg, fg = colors.fg }, c = { bg = colors.bg, fg = colors.fg } },
            command = { a = { bg = colors.yellow, fg = colors.bg, gui = "bold" }, b = { bg = colors.bg, fg = colors.fg }, c = { bg = colors.bg, fg = colors.fg } },
            replace = { a = { bg = colors.red, fg = colors.bg, gui = "bold" }, b = { bg = colors.bg, fg = colors.fg }, c = { bg = colors.bg, fg = colors.fg } },
            inactive = { a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" }, b = { bg = colors.inactive_bg, fg = colors.semilightgray }, c = { bg = colors.inactive_bg, fg = colors.semilightgray } },
          }
          lualine.setup({
            options = { theme = my_lualine_theme },
            sections = {
              lualine_x = {
                { "encoding" },
                { "fileformat", symbols = { unix = " " } },
                { "filetype" },
              },
            },
          })
        '';
      }
      {
        plugin = tokyonight-nvim;
        type = "lua";
        config = ''
          require("tokyonight").setup({
            style = "night",
            transparent = false,
            on_colors = function(colors)
              colors.bg = "#011628"
              colors.bg_dark = "#011423"
              colors.bg_float = "#011423"
              colors.bg_highlight = "#143652"
              colors.bg_popup = "#011423"
              colors.bg_search = "#0A64AC"
              colors.bg_sidebar = "#011423"
              colors.bg_statusline = "#011423"
              colors.bg_visual = "#275378"
              colors.border = "#547998"
              colors.fg = "#CBE0F0"
              colors.fg_dark = "#B4D0E9"
              colors.fg_float = "#CBE0F0"
              colors.fg_gutter = "#627E97"
              colors.fg_sidebar = "#B4D0E9"
            end,
          })
          vim.cmd("colorscheme tokyonight")
        '';
      }
      dressing-nvim
      indent-blankline-nvim

      # Navigation & Search
      {
        plugin = nvim-tree-lua;
        type = "lua";
        config = ''
          vim.g.loaded_netrw = 1
          vim.g.loaded_netrwPlugin = 1
          require("nvim-tree").setup({
            view = { width = 50, relativenumber = true },
            renderer = {
              indent_markers = { enable = true },
              icons = { glyphs = { folder = { arrow_closed = "", arrow_open = "" } } }
            },
            actions = { open_file = { window_picker = { enable = false } } },
            filters = { custom = { ".DS_Store" } },
            git = { ignore = false },
          })
          local keymap = vim.keymap
          keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
          keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle file explorer on current file" })
          keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
          keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
        '';
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local telescope = require("telescope")
          local actions = require("telescope.actions")
          telescope.setup({
            defaults = {
              path_display = { "smart" },
              mappings = {
                i = {
                  ["<C-k>"] = actions.move_selection_previous,
                  ["<C-j>"] = actions.move_selection_next,
                },
              },
            },
          })
          telescope.load_extension("fzf")
          local keymap = vim.keymap
          keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
          keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
          keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
          keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
          keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
          keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<cr>", { desc = "Find keymaps" })
        '';
      }
      telescope-fzf-native-nvim

      # Git & Others
      {
        plugin = auto-session;
        type = "lua";
        config = ''
          require("auto-session").setup({
            auto_restore_enabled = false,
            auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
          })
          vim.keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session for cwd" })
          vim.keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session" })
        '';
      }
      {
        plugin = todo-comments-nvim;
        type = "lua";
        config = ''
          local todo_comments = require("todo-comments")
          vim.keymap.set("n", "]t", function() todo_comments.jump_next() end, { desc = "Next todo comment" })
          vim.keymap.set("n", "[t", function() todo_comments.jump_prev() end, { desc = "Previous todo comment" })
          todo_comments.setup()
        '';
      }
      trouble-nvim
      vim-tmux-navigator
      vim-maximizer
      which-key-nvim

      # Editing Support
      {
        plugin = comment-nvim;
        type = "lua";
        config = ''
          require("Comment").setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
          })
        '';
      }
      nvim-ts-context-commentstring
      {
        plugin = nvim-autopairs;
        type = "lua";
        config = ''
          require("nvim-autopairs").setup({
            check_ts = true,
            ts_config = { lua = { "string" }, javascript = { "template_string" } },
          })
          require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
        '';
      }
      nvim-surround
      {
        plugin = substitute-nvim;
        type = "lua";
        config = ''
          local substitute = require("substitute")
          substitute.setup()
          local keymap = vim.keymap
          keymap.set("n", "<leader>r", substitute.operator, { desc = "Substitute with motion" })
          keymap.set("n", "<leader>rr", substitute.line, { desc = "Substitute line" })
          keymap.set("n", "<leader>R", substitute.eol, { desc = "Substitute to end of line" })
          keymap.set("x", "<leader>r", substitute.visual, { desc = "Substitute in visual mode" })
        '';
      }

      # Completion & Snippets
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require("cmp")
          local luasnip = require("luasnip")
          local lspkind = require("lspkind")
          require("luasnip.loaders.from_vscode").lazy_load()
          cmp.setup({
            snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
            mapping = cmp.mapping.preset.insert({
              ["<C-k>"] = cmp.mapping.select_prev_item(),
              ["<C-j>"] = cmp.mapping.select_next_item(),
              ["<C-b>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.abort(),
              ["<CR>"] = cmp.mapping.confirm({ select = false }),
            }),
            sources = cmp.config.sources({
              { name = "nvim_lsp" },
              { name = "luasnip" },
              { name = "buffer" },
              { name = "path" },
            }),
            formatting = {
              format = lspkind.cmp_format({ maxwidth = 50, ellipsis_char = "..." }),
            },
          })
        '';
      }
      cmp-buffer
      cmp-path
      cmp_luasnip
      luasnip
      friendly-snippets
      lspkind-nvim

      # Treesitter
      {
        plugin = (nvim-treesitter.withAllGrammars);
        type = "lua";
        config = ''
          require("nvim-treesitter.configs").setup({
            highlight = { enable = true },
            indent = { enable = true },
            incremental_selection = {
              enable = true,
              keymaps = {
                init_selection = "<C-space>",
                node_incremental = "<C-space>",
                scope_incremental = false,
                node_decremental = "<bs>",
              },
            },
          })
          vim.treesitter.language.register("bash", "zsh")
        '';
      }
    ];

    extraLuaConfig = ''
      -- Options
      vim.cmd("let g:netrw_liststyle = 3")
      local opt = vim.opt
      opt.relativenumber = true
      opt.number = true
      opt.tabstop = 2
      opt.shiftwidth = 2
      opt.expandtab = true
      opt.autoindent = true
      opt.wrap = false
      opt.ignorecase = true
      opt.smartcase = true
      opt.cursorline = true
      opt.termguicolors = true
      opt.background = "dark"
      opt.signcolumn = "yes"
      opt.backspace = "indent,eol,start"
      opt.clipboard:append("unnamedplus")
      opt.splitright = true
      opt.splitbelow = true

      -- Keymaps
      vim.g.mapleader = " "
      local keymap = vim.keymap
      keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
      keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
      keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
      keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })
      keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
      keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
      keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
      keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })
      keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
      keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
      keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
      keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
      keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
    '';
  };
}
