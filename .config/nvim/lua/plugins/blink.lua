return {
  "saghen/blink.cmp",
  version = "*",
  opts = {
    sources = {
      -- 1. Define the default list (order here doesn't strictly dictate priority)
      default = { "lsp", "path", "snippets", "buffer", "copilot" },

      -- 2. Explicitly set priorities for all sources
      providers = {
        lsp = {
          name = "LSP",
          enabled = true,
          module = "blink.cmp.sources.lsp",
          score_offset = 100, -- Highest priority: keep real code symbols at the top
          kind = "Symbol",
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 50, -- High priority for file paths
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = 20, -- Snippets above general text but below LSP
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = 0, -- Default baseline
        },
        copilot = {
          name = "copilot",
          module = "blink-copilot", -- Ensure you have blink-copilot installed
          score_offset = -100, -- Lowest priority: always at the bottom
          kind = "Copilot",
        },
      },
    },

    completion = {
      menu = {
        border = "rounded", -- Eye candy border
        scrollbar = true, -- Functional scrolling
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
          border = "rounded", -- Matching border for docs
          scrollbar = true, -- Scroll through long docs
        },
      },
      ghost_text = {
        enabled = false,
      },
    },

    signature = {
      enabled = true,
      window = {
        border = "rounded", -- Rounded borders for function signatures too
      },
    },

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
