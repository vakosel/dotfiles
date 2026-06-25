return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },

  opts = function()
    return {
      --------------------------------------------------------------------
      -- REGISTER MULTIPLE ADAPTERS (Copilot AND Claude)
      --------------------------------------------------------------------
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "gpt-4o",
              },
            },
          })
        end,

        -- Requires `export ANTHROPIC_API_KEY="your_key"` in your .bashrc/.zshrc
        anthropic = function()
          return require("codecompanion.adapters").extend("anthropic", {
            schema = {
              model = {
                default = "claude-3-5-sonnet-latest",
              },
            },
          })
        end,
      },

      --------------------------------------------------------------------
      -- DEFAULT INTERACTIONS (Latest CodeCompanion v19+ Structure)
      --------------------------------------------------------------------
      interactions = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },

      --------------------------------------------------------------------
      -- UI Settings
      --------------------------------------------------------------------
      display = {
        chat = {
          window = {
            layout = "float",
            border = "rounded",
            width = 0.5,
            height = 0.8,
          },
          show_settings = false, -- Kept false so you can cleanly use 'ga' menu to swap
          render_headers = true,
        },
        diff = {
          provider = "mini_diff",
        },
      },
    }
  end,

  --------------------------------------------------------------------------
  -- KEYMAPS
  --------------------------------------------------------------------------
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    { "<leader>ce", "<cmd>CodeCompanion /explain<cr>", mode = "v", desc = "AI Explain" },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to Chat" },
  },
}
