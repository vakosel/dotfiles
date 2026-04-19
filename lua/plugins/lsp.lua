return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.ensure_installed = opts.ensure_installed or {}

      table.insert(opts.ensure_installed, "basedpyright")
      table.insert(opts.ensure_installed, "ruff")
      table.insert(opts.ensure_installed, "lua_ls")
      table.insert(opts.ensure_installed, "taplo")

      opts.servers.pyright = nil

      vim.o.updatetime = 300

      -----------------------------------------------------------------------
      -- PYTHON
      -----------------------------------------------------------------------
      opts.servers.basedpyright = {
        -- This forces the server to start with ONLY utf-16 support
        capabilities = {
          offsetEncoding = { "utf-16" },
          general = {
            positionEncodings = { "utf-16" },
          },
        },
        settings = {
          basedpyright = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
        -- This is the "Safety Catch": it stops other plugins from
        -- adding utf-8 back into the capabilities later.
        on_new_config = function(new_config, _)
          new_config.capabilities.offsetEncoding = { "utf-16" }
          if new_config.capabilities.general then
            new_config.capabilities.general.positionEncodings = { "utf-16" }
          end
        end,
      }
      opts.servers.ruff = {
        capabilities = {
          -- Ruff is modern and requires this specific nesting
          general = {
            positionEncodings = { "utf-16" },
          },
        },
        on_attach = function(client)
          client.server_capabilities.hoverProvider = false
        end,
      }

      -----------------------------------------------------------------------
      -- LUA
      -----------------------------------------------------------------------
      opts.servers.lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      }

      -----------------------------------------------------------------------
      -- TOML
      -----------------------------------------------------------------------
      opts.servers.taplo = {}
    end,
  },
}
