return {
  "catppuccin/nvim",
  name = "catppuccin-macchiato",
  priority = 1000,
  setup = function()
    require("catppuccin").setup({
      flavour = "macchiato",
      integrations = {
        ts_rainbow = true,
      },
    })
  end,
}
