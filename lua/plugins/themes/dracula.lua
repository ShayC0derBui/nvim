return {
  {
    "Mofiqul/dracula.nvim",
    config = function()
      require("dracula").setup({
        theme = "dracula-soft",
        colors = {
          bg = "#292A35",
          fg = "#F6F6F5",
          selection = "#323544",
          comment = "#70747f",
          orange = "#FDC38E",
          black = "#1C1C1C",
          red = "#DD6E6B",
          green = "#87E58E",
          yellow = "#E8EDA2",
          purple = "#BAA0E8",
          pink = "#E48CC1",
          cyan = "#A7DFEF",
          white = "#F6F6F5",
          bright_red = "#E1837F",
          bright_green = "#97EDA2",
          bright_yellow = "#F6F6B6",
          bright_blue = "#D0B5F3",
          bright_magenta = "#E7A1D7",
          bright_cyan = "#BCF4F5",
          bright_white = "#FFFFFF",
          menu = "#21222C",
          visual = "#3E4452",
          gutter_fg = "#4B5263",
          nontext = "#3B4048",
        },
        show_end_of_buffer = true,
        transparent_bg = true,
        lualine_bg_color = "#44475a",
        italic_comment = true,
        overrides = {},
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "dracula-soft",
    },
  },
}
