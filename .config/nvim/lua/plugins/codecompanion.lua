return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- Note: Ensure zbirenbaum/copilot.lua or github/copilot.vim is installed
    -- as codecompanion relies on them for authentication.
  },

  opts = function()
    return {
      --------------------------------------------------------------------
      -- REGISTER THE ADAPTERS
      --------------------------------------------------------------------
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "gpt-4o", -- Smooth, fast, and uniform across OSes
              },
            },
          })
        end,
      },

      --------------------------------------------------------------------
      -- STRATEGIES (Copilot everywhere)
      --------------------------------------------------------------------
      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
        agent = { adapter = "copilot" },
      },

      --------------------------------------------------------------------
      -- UI (minimal, stable)
      --------------------------------------------------------------------
      display = {
        chat = {
          window = {
            layout = "float",
            border = "rounded",
            width = 0.5,
            height = 0.8,
          },
          show_settings = false,
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
