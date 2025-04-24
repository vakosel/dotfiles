-- ~/.config/wezterm/colors/custom.lua

local wezterm = require('wezterm')

-- Load pywal colors
local home = os.getenv('HOME')
local wal_colors_path = home .. '/.cache/wal/colors.json'

local function get_wal_colors()
   local success, content = pcall(function()
      local f = io.open(wal_colors_path, 'r')
      if f then
         local data = f:read('*a')
         f:close()
         return wezterm.json_parse(data)
      end
   end)

   if success and content then
      return {
         foreground = content.special.foreground,
         background = content.special.background,
         cursor_bg = content.special.cursor,
         cursor_border = content.special.cursor,
         cursor_fg = content.special.background,
         selection_bg = content.colors.color2,
         selection_fg = content.colors.color0,
         ansi = {
            content.colors.color0,
            content.colors.color1,
            content.colors.color2,
            content.colors.color3,
            content.colors.color4,
            content.colors.color5,
            content.colors.color6,
            content.colors.color7,
         },
         brights = {
            content.colors.color8,
            content.colors.color9,
            content.colors.color10,
            content.colors.color11,
            content.colors.color12,
            content.colors.color13,
            content.colors.color14,
            content.colors.color15,
         },
         tab_bar = {
            background = content.colors.color0,
            active_tab = {
               bg_color = content.colors.color2,
               fg_color = content.special.foreground,
               intensity = 'Bold',
            },
            inactive_tab = {
               bg_color = content.colors.color0,
               fg_color = content.colors.color8,
            },
            inactive_tab_hover = {
               bg_color = content.colors.color1,
               fg_color = content.special.foreground,
            },
            new_tab = {
               bg_color = content.colors.color0,
               fg_color = content.colors.color7,
            },
            new_tab_hover = {
               bg_color = content.colors.color3,
               fg_color = content.special.foreground,
               italic = true,
            },
         },
      }
   end

   return nil
end

-- Mocha fallback (your existing theme)
local mocha = {
   rosewater = '#f5e0dc',
   flamingo = '#f2cdcd',
   pink = '#f5c2e7',
   mauve = '#cba6f7',
   red = '#f38ba8',
   maroon = '#eba0ac',
   peach = '#fab387',
   yellow = '#f9e2af',
   green = '#a6e3a1',
   teal = '#94e2d5',
   sky = '#89dceb',
   sapphire = '#74c7ec',
   blue = '#89b4fa',
   lavender = '#b4befe',
   text = '#cdd6f4',
   subtext1 = '#bac2de',
   subtext0 = '#a6adc8',
   overlay2 = '#9399b2',
   overlay1 = '#7f849c',
   overlay0 = '#6c7086',
   surface2 = '#585b70',
   surface1 = '#45475a',
   surface0 = '#313244',
   base = '#1f1f28',
   mantle = '#181825',
   crust = '#11111b',
}

local fallback = {
   foreground = mocha.text,
   background = mocha.base,
   cursor_bg = mocha.rosewater,
   cursor_border = mocha.rosewater,
   cursor_fg = mocha.crust,
   selection_bg = mocha.surface2,
   selection_fg = mocha.text,
   ansi = {
      '#0C0C0C',
      '#C50F1F',
      '#13A10E',
      '#C19C00',
      '#0037DA',
      '#881798',
      '#3A96DD',
      '#CCCCCC',
   },
   brights = {
      '#767676',
      '#E74856',
      '#16C60C',
      '#F9F1A5',
      '#3B78FF',
      '#B4009E',
      '#61D6D6',
      '#F2F2F2',
   },
   tab_bar = {
      background = 'rgba(0, 0, 0, 0.4)',
      active_tab = { bg_color = mocha.surface2, fg_color = mocha.text },
      inactive_tab = { bg_color = mocha.surface0, fg_color = mocha.subtext1 },
      inactive_tab_hover = { bg_color = mocha.surface0, fg_color = mocha.text },
      new_tab = { bg_color = mocha.base, fg_color = mocha.text },
      new_tab_hover = { bg_color = mocha.mantle, fg_color = mocha.text, italic = true },
   },
   visual_bell = mocha.red,
   indexed = {
      [16] = mocha.peach,
      [17] = mocha.rosewater,
   },
   scrollbar_thumb = mocha.surface2,
   split = mocha.overlay0,
   compose_cursor = mocha.flamingo,
}

return get_wal_colors() or fallback
