-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

cfg = {
  debug = false, -- set to true to enable debug logging
  log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
  -- default is  ~/.cache/nvim/lsp_signature.log
  verbose = false, -- show debug line number

  bind = true, -- This is mandatory, otherwise border config won't get registered.
  -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 10, -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
  -- set to 0 if you DO NOT want any API comments be shown
  -- This setting only take effect in insert mode, it does not affect signature help in normal
  -- mode, 10 by default

  max_height = 12, -- max height of signature floating_window
  max_width = 80, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  -- the value need >= 40
  wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
  floating_window = true, -- show hint in a floating window, set to false for virtual text only mode

  floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
  -- will set to true when fully tested, set to false will use whichever side has more space
  -- this setting will be helpful if you do not want the PUM and floating win overlap

  floating_window_off_x = 1, -- adjust float windows x position.
  -- can be either a number or function
  floating_window_off_y = 0, -- adjust float windows y position. e.g -2 move window up 2 lines; 2 move down 2 lines
  -- can be either number or function, see examples

  close_timeout = 4000, -- close floating window after ms when laster parameter is entered
  fix_pos = false, -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = true, -- virtual hint enable
  hint_prefix = "🐼 ", -- Panda for parameter, NOTE: for the terminal not support emoji, might crash
  hint_scheme = "String",
  hint_inline = function()
    return false
  end, -- should the hint be inline(nvim 0.10 only)?  default false
  -- return true | 'inline' to show hint inline, return 'eol' to show hint at end of line, return false to disable
  -- return 'right_align' to display hint right aligned in the current line
  hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
  handler_opts = {
    border = "rounded", -- double, rounded, single, shadow, none, or a table of borders
  },

  always_trigger = false, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

  auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
  extra_trigger_chars = {}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
  zindex = 200, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

  padding = "", -- character to pad on left and right of signature can be ' ', or '|'  etc

  transparency = nil, -- disabled by default, allow floating win transparent value 1~100
  shadow_blend = 36, -- if you using shadow as border use this set the opacity
  shadow_guibg = "Black", -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  timer_interval = 200, -- default timer check interval set to lower value if you want to reduce latency
  toggle_key = "<C-k>", -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
  toggle_key_flip_floatwin_setting = false, -- true: toggle floating_windows: true|false setting after toggle key pressed
  -- false: floating_windows setup will not change, toggle_key will pop up signature helper, but signature
  -- may not popup when typing depends on floating_window setting

  select_signature_key = nil, -- cycle to next signature, e.g. '<M-n>' function overloading
  move_cursor_key = nil, -- imap, use nvim_set_current_win to move cursor between current win and floating
}

-- recommended:
require("lsp_signature").setup(cfg) -- no need to specify bufnr if you don't use toggle_key

-- You can also do this inside lsp on_attach
-- note: on_attach deprecated
-- require("lsp_signature").on_attach(cfg, bufnr) -- no need to specify bufnr if you don't use toggle_key

-- Key mapping for toggling signature help floating window
-- vim.keymap.set({ "i" }, "<C-k>", function()
--   require("lsp_signature").toggle_float_win()
-- end, { silent = true, noremap = true, desc = "toggle signature" })

-- Key mapping for requesting signature help from language server
vim.keymap.set({ "n" }, "<C-k>", function()
  vim.lsp.buf.signature_help()
end, { silent = true, noremap = true, desc = "toggle signature" })

vim.g.better_escape_interval = 70

-- local dracula = require("dracula")
-- dracula.setup({
--   -- customize dracula color palette
--   theme = "dracula-soft",
--   ---@type Palette
--   colors = {
--     bg = "#292A35", --
--     fg = "#F6F6F5",
--     selection = "#4B5263",
--     comment = "#70747f",
--     orange = "#FDC38E",
--     -- ANSI
--     black = "#1C1C1C", -- ANSI 0
--     red = "#DD6E6B",
--     green = "#87E58E",
--     yellow = "#E8EDA2",
--     purple = "#BAA0E8", -- used as ANSI 4 (blue)
--     pink = "#E48CC1",
--     cyan = "#A7DFEF",
--     white = "#F6F6F5", -- ANSI 7, 'selection' used for ANSI 8
--     -- indexes 9-15
--     bright_red = "#E1837F",
--     bright_green = "#97EDA2",
--     bright_yellow = "#F6F6B6",
--     bright_blue = "#D0B5F3",
--     bright_magenta = "#E7A1D7",
--     bright_cyan = "#BCF4F5",
--     bright_white = "#FFFFFF", -- index 15
--
--     menu = "#21222C",
--     visual = "#3E4452",
--     gutter_fg = "#4B5263",
--     nontext = "#3B4048",
--   },
--   -- show the '~' characters after the end of buffers
--   show_end_of_buffer = true, -- default false
--   -- use transparent background
--   transparent_bg = true, -- default false
--   -- set custom lualine background color
--   lualine_bg_color = "#44475a", -- default nil
--   -- set italic comment
--   italic_comment = true, -- default false
--   -- overrides the default highlights with table see `:h synIDattr`
--   overrides = {},
--   -- You can use overrides as table like this
--   -- overrides = {
--   --   NonText = { fg = "white" }, -- set NonText fg to white
--   --   NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
--   --   Nothing = {} -- clear highlight of Nothing
--   -- },
--   -- Or you can also use it like a function to get color from theme
--   -- overrides = function (colors)
--   --   return {
--   --     NonText = { fg = colors.white }, -- set NonText fg to white of theme
--   --   }
--   -- end,
-- })
