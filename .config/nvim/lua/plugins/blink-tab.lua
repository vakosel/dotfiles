return {
  "saghen/blink.cmp",
  opts = {
    signature = { enabled = true },
    keymap = {
      ["<Tab>"] = {
        "select_next", -- move to next item
        "snippet_forward", -- or snippet jump
        "fallback", -- or insert tab if nothing else
      },
      ["<S-Tab>"] = {
        "select_prev", -- move to previous item
        "snippet_backward", -- or jump back
        "fallback", -- or do nothing
      },
      ["<CR>"] = {
        "accept", -- confirm selected or first item
        "fallback", -- if nothing, insert newline
      },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide" },
      ["<C-u>"] = { "scroll_documentation_up", "fallback" },
      ["<C-d>"] = { "scroll_documentation_down", "fallback" },
      preset = "super-tab", -- keep this for Blink-style context
    },
  },
}
