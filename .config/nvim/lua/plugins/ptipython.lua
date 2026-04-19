return {
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.40)
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.40)
        end
      end,
    })

    local Terminal = require("toggleterm.terminal").Terminal

    -- Horizontal ptipython
    local ptipython_h = Terminal:new({
      cmd = "uv run ptipython",
      direction = "horizontal",
      hidden = true,
    })

    vim.keymap.set("n", "<leader>ph", function()
      ptipython_h:toggle()
    end, { desc = "ptipython (horizontal)" })

    -- Vertical ptipython
    local ptipython_v = Terminal:new({
      cmd = "uv run ptipython",
      direction = "vertical",
      hidden = true,
    })

    vim.keymap.set("n", "<leader>pv", function()
      ptipython_v:toggle()
    end, { desc = "ptipython (vertical)" })

    -------------------------------------------------------------------------
    -- SEND CODE TO PTIPYTHON (Iron.nvim replacement)
    -------------------------------------------------------------------------

    -- Helper: send text to a given ptipython terminal
    local function send_to_ptipython(text, term)
      term:toggle() -- ensure terminal is open
      term:send(text) -- send text
    end

    -- Send visual selection
    vim.keymap.set("v", "<leader>ss", function()
      local term = ptipython_h

      -- capture selection BEFORE visual mode ends
      local start = vim.fn.getpos("'<")
      local finish = vim.fn.getpos("'>")

      local start_row = start[2] - 1
      local start_col = start[3] - 1
      local end_row = finish[2] - 1
      local end_col = finish[3]

      -- extract exact text
      local lines = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
      local text = table.concat(lines, "\n")

      -- open REPL AFTER capturing text
      term:toggle()
      term:send(text)
    end, { desc = "Send selection to ptipython", silent = true })

    -- Send current line
    vim.keymap.set("n", "<leader>sl", function()
      local term = ptipython_h
      local line = vim.api.nvim_get_current_line() .. "\n"
      send_to_ptipython(line, term)
    end, { desc = "Send line to ptipython" })

    -- Send entire file
    vim.keymap.set("n", "<leader>sf", function()
      local term = ptipython_h
      local buf = vim.api.nvim_get_current_buf()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local text = table.concat(lines, "\n") .. "\n"
      send_to_ptipython(text, term)
    end, { desc = "Send file to ptipython" })
  end,
}
