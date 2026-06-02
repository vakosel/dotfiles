return {
  "saghen/blink.cmp",
  version = "*",

  -- 1. Ensure the copilot completion bridge is installed
  dependencies = {
    { "giuxtaposition/blink-cmp-copilot" },
  },

  opts = {
    sources = {
      -- 2. Your exact requested order: LSP and files first, Copilot dead last
      default = { "lsp", "path", "buffer", "copilot" },

      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = -100, -- Absolutely locks it to the bottom of the list
          async = true,
        },
      },
    },

    completion = {
      menu = {
        border = "rounded", -- Eye candy rounded windows
        scrollbar = true,
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = "rounded",
          scrollbar = true,
        },
      },
      -- 3. Turn inline ghost text ON
      ghost_text = {
        enabled = true,
      },
    },

    signature = {
      enabled = true,
      window = {
        border = "rounded",
      },
    },

    -- 4. Your working Super-Tab keymaps
    keymap = {
      preset = "super-tab",
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
    },
  },
}
