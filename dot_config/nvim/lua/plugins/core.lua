-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      opts = opts or {}
      opts.sources = opts.sources or {}
      table.insert(opts.sources, { name = "emoji" })
      return opts
    end,
  },

  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      -- see: https://github.com/LazyVim/LazyVim/discussions/3191
      inlay_hints = { enabled = false },
      ---@type lspconfig.options
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
        terraformls = {},
        pyright = {},
        tsserver = false, -- Explicitly disable TypeScript LSP
        ts_ls = false, -- Deno/TypeScript LSP - Simple conflict avoidance
        denols = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("deno.json", "deno.jsonc")(fname)
          end,
          init_options = {
            lint = true,
            unstable = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://deno.land"] = true,
                  ["https://cdn.nest.land"] = true,
                  ["https://crux.land"] = true,
                },
              },
            },
          },
          settings = {
            deno = {
              enable = true,
              lint = true,
              unstable = true,
            },
          },
          on_attach = function(client, bufnr)
            local util = require("lspconfig.util")
            local is_node_dir = util.root_pattern("package.json")(vim.fn.getcwd())
            if is_node_dir then
              client.stop(true)
            end
          end,
        },
        vtsls = {
          root_dir = function(fname)
            local util = require("lspconfig.util")
            return util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(fname)
          end,
          single_file_support = false,
          on_attach = function(client, bufnr)
            local util = require("lspconfig.util")
            local is_node_dir = util.root_pattern("package.json")(vim.fn.getcwd())
            if not is_node_dir then
              client.stop(true)
            end
          end,
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
      setup = {
        -- Explicitly disable TypeScript LSP
        tsserver = function() return true end,
        ts_ls = function() return true end,
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "gopls" then
                if not client.server_capabilities.semanticTokensProvider then
                  local semantic = client.config.capabilities.textDocument.semanticTokens
                  client.server_capabilities.semanticTokensProvider = {
                    full = true,
                    legend = {
                      tokenTypes = semantic.tokenTypes,
                      tokenModifiers = semantic.tokenModifiers,
                    },
                    range = true,
                  }
                end
              end
            end,
          })
          -- end workaround
        end,
      },
    },
  },

  -- add more treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "tsx",
        "typescript",
        "vim",
        "yaml",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "dockerfile",
        "ninja",
        "rst",
        "terraform",
        "hcl",
        "haskell",
      },
    },
  },

  -- since `vim.tbl_deep_extend`, can only merge tables and not lists, the code above
  -- would overwrite `ensure_installed` with the new value.
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts = opts or {}
      opts.ensure_installed = opts.ensure_installed or {}
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
      })
      return opts
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "LazyFile",
    opts = function()
      local tsc = require("treesitter-context")
      Snacks.toggle({
        name = "Treesitter Context",
        get = tsc.enabled,
        set = function(state)
          if state then
            tsc.enable()
          else
            tsc.disable()
          end
        end,
      }):map("<leader>ut")
      return { mode = "cursor", max_lines = 3 }
    end,
  },

  -- use mini.starter instead of alpha
  -- { import = "lazyvim.plugins.extras.ui.mini-starter" },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  -- { import = "lazyvim.plugins.extras.lang.json" },

  -- add any tools you want to have installed below
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "gomodifytags",
        "impl",
        "gotests",
        "gopls",
        "goimports",
        "golines",
        "gofumpt",
        "delve",
        "typescript-language-server",
        "deno",
        "hadolint",
        "tflint",
        "haskell-language-server",
      },
    },
  },
}
