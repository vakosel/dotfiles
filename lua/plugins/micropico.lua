return {
  "jim-at-jibba/micropython.nvim",
  config = function()
    require("micropython_nvim").setup({
      device = "/dev/ttyACM0",
      baudrate = 115200,
    })

    ---------------------------------------------------------
    -- REAL REPL (Thonny-style)
    ---------------------------------------------------------
    vim.keymap.set("n", "<leader>mp", function()
      vim.cmd("belowright split | terminal mpremote repl")
    end, { desc = "Open MicroPython REPL" })

    ---------------------------------------------------------
    -- RUN CURRENT FILE WITH WORKING CTRL+C
    -- (mpremote execfile instead of MPRun)
    ---------------------------------------------------------

    vim.keymap.set("n", "<leader>mr", function()
      local file = vim.fn.expand("%:p")
      os.execute("wezterm -e mpremote run " .. file .. " &")
    end, { desc = "Run file in external terminal" })

    ---------------------------------------------------------
    -- UPLOAD CURRENT FILE TO THE PICO
    ---------------------------------------------------------
    vim.keymap.set("n", "<leader>mu", function()
      local file = vim.fn.expand("%:p")
      local name = vim.fn.expand("%:t")
      vim.cmd("terminal mpremote cp " .. file .. " :" .. name)
    end, { desc = "Upload current file to Pico" })

    ---------------------------------------------------------
    -- SAFE STOP: send Ctrl+C + reset pin state
    ---------------------------------------------------------
    vim.keymap.set("n", "<leader>ms", function()
      vim.cmd(
        'terminal mpremote exec "import machine; machine.PWM(machine.Pin(15)).deinit(); machine.Pin(15, machine.Pin.OUT).value(0)"'
      )
    end, { desc = "Stop PWM + turn LED off" })
  end,
}
