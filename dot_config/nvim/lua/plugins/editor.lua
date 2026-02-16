return {
  -- terminal
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      {
        "<C-\\>",
        "<cmd>ToggleTerm direction=vertical<cr>",
        desc = "Toggle terminal",
      },
    },
    -- see: https://github.com/LunarVim/LunarVim/blob/master/lua/lvim/core/terminal.lua#L4-L53
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return 10
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.3
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = "vertical",
      close_on_exit = true,
      auto_scroll = true,
      shell = nil,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
      winbar = {
        enabled = false,
      },
      on_open = function(term)
        local opts = { buffer = term.bufnr }
        vim.keymap.set("t", "jj", "<C-\\><C-n>", opts)
      end,
    },
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
      {
        "<leader>fh",
        function()
          require("telescope.builtin").find_files({
            hidden = true,
            cwd = LazyVim.root(),
          })
        end,
        desc = "Find Files (hidden, Root Dir)",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- file explorer
  -- {
  --   "mikavilpas/yazi.nvim",
  --   event = "VeryLazy",
  --   keys = {
  --     {
  --       "<C-e>",
  --       "<cmd>Yazi<cr>",
  --       desc = "Open yazi at the current file",
  --     },
  --   },
  --   opts = {
  --     open_for_directories = false,
  --     keymaps = {
  --       show_help = "<f1>",
  --     },
  --   },
  -- },

  {
    "lambdalisue/vim-fern",
    dependencies = {
      "lambdalisue/fern-renderer-nerdfont.vim",
      "lambdalisue/nerdfont.vim",
    },
    keys = {
      {
        "<C-e>",
        "<cmd>Fern . -reveal=% -drawer -toggle -width=20<cr>",
        desc = "Toggle Fern file explorer",
      },
    },
    config = function()
      vim.g["fern#default_hidden"] = 1
      vim.g["fern#renderer"] = "nerdfont"
    end,
  },

  -- Finds and lists all of the TODO, HACK, BUG, etc comment in your project and loads them into a browsable list.
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "LazyFile",
    opts = {},
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- auto save
  {
    "okuuva/auto-save.nvim",
    version = "^1.0.0",
    cmd = "ASToggle",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      debounce_delay = 200,
    },
  },

  -- inline diagnostics
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    keys = {
      {
        "<leader>cd",
        function()
          local float_win = vim.diagnostic.open_float(nil, {
            scope = "cursor",
            focusable = true,
            header = "",
          })
          if float_win then
            vim.api.nvim_set_current_win(float_win)
          end
        end,
        desc = "Focus diagnostic float",
      },
    },
    config = function()
      require("tiny-inline-diagnostic").setup({
        enable_on_insert = false,
        enable_on_select = true,
      })
      vim.diagnostic.config({ virtual_text = false })
    end,
  },

  -- current code context
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          local buffer = args.buf
          if client and client.supports_method("textDocument/documentSymbol") then
            require("nvim-navic").attach(client, buffer)
          end
        end,
      })
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = LazyVim.config.icons.kinds,
        lazy_update_context = true,
      }
    end,
  },

  -- git
  {
    "FabijanZulj/blame.nvim",
    keys = {
      {
        "<leader>gm",
        "<cmd>BlameToggle<cr>",
        desc = "Git Blame",
      },
    },
    config = function()
      require("blame").setup({})
    end,
  },

  -- snippets
  {
    "SirVer/ultisnips",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<c-b>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<c-z>"
      vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
    end,
  },

  -- window resizer
  {
    "simeji/winresizer",
    keys = {
      {
        "<C-w>",
        "<cmd>WinResizerStartResize<cr>",
        desc = "Start window resize mode",
        mode = { "n", "t" },
      },
    },
    init = function()
      vim.g.winresizer_start_key = ""
    end,
  },

  -- image viewer
  {
    "3rd/image.nvim",
    event = "VeryLazy",
    build = false,
    opts = {
      backend = "kitty", -- ghostty also supports kitty graphics protocol
      processor = "magick_cli",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
        },
        neorg = {
          enabled = false,
        },
      },
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- disable markdown formatters
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        markdown = {},
      },
    },
  },

  -- disable markdown linters
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = {},
      },
    },
  },
}
