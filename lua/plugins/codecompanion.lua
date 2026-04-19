return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = function()
    -- Use the internal Neovim check for Windows
    local is_windows = vim.fn.has("win32") == 1

    local active_adapter = is_windows and "ollama" or "copilot"

    return {
      strategies = {
        chat = { adapter = active_adapter },
        inline = { adapter = active_adapter },
        agent = { adapter = active_adapter },
      },

      adapters = {
        -- Your Windows setup (4090 + 64GB RAM)
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "qwen-beast", -- The 32B Architect
                choices = {
                  "qwen-beast", -- 32B
                  "qwen14", -- 14B
                  "qwen7", -- 7B
                },
              },
              num_ctx = {
                -- This function dynamically changes the context based on your model!
                default = function(self)
                  local model = self.model
                  if model == "qwen7" then
                    return 65536 -- 64k for the fast model (massive memory)
                  elseif model == "qwen14" then
                    return 32768 -- 32k for the middle model
                  else
                    return 16384 -- 16k for the 32B (safest for 24GB VRAM)
                  end
                end,
              },
            },
          })
        end,
        -- Your Linux setup (Manjaro + Raspberry Pi)
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = { default = "gpt-4o" },
            },
          })
        end,
      },
      display = {
        chat = {
          window = {
            layout = "float", -- Float it like a pro
            border = "rounded",
            width = 0.45,
            height = 0.8,
          },
          show_settings = false, -- Keep it clean
          render_headers = true, -- Looks better with highlights
        },
        diff = {
          provider = "mini_diff", -- Super smooth diffing if you have mini.nvim
        },
      },
    }
  end,
  keys = {
    { "<leader>cc", "<cmd>CodeCompanionChat toggle<cr>", mode = { "n", "v" }, desc = "AI Chat" },
    { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    { "<leader>ce", "<cmd>CodeCompanion /explain<cr>", mode = { "v" }, desc = "AI Explain" },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "Add to Chat", mode = "v" },
  },
}
