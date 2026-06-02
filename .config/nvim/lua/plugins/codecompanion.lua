return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },

  opts = function()
    local is_windows = vim.fn.has("win32") == 1

    ----------------------------------------------------------------------
    -- STRATEGY SELECTION BY OS
    ----------------------------------------------------------------------
    -- We select the adapter string name based on the OS
    local active_adapter = is_windows and "llamacpp" or "copilot"

    return {
      --------------------------------------------------------------------
      -- REGISTER THE ADAPTERS
      --------------------------------------------------------------------
      adapters = {
        llamacpp = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              url = "http://127.0.0.1:8080",
              api_key = "dummy",
            },
            schema = {
              model = {
                default = "Qwen3.6-35B-A3B-UD-Q4_K_M.gguf",
              },
            },
          })
        end,

        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "gpt-4o",
              },
            },
          })
        end,
      },

      --------------------------------------------------------------------
      -- STRATEGIES (Using String References)
      --------------------------------------------------------------------
      strategies = {
        chat = { adapter = active_adapter },
        inline = { adapter = active_adapter },
        agent = { adapter = active_adapter },
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
