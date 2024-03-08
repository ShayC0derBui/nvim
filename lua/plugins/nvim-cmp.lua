return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  event = "InsertEnter",
  dependencies = {
    -- nvim-cmp source for neovim builtin LSP client
    "hrsh7th/cmp-nvim-lsp",
    -- nvim-cmp source for buffer words
    "hrsh7th/cmp-buffer",
    -- nvim-cmp source for path
    "hrsh7th/cmp-path",
    -- nvim-cmp source for emoji
    "hrsh7th/cmp-emoji",
    -- Luasnip completion source for nvim-cmp
    "saadparwaiz1/cmp_luasnip",
    -- Tmux completion source for nvim-cmp
    "andersevenrud/cmp-tmux",
  },
  opts = function()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    local luasnip = require("luasnip")

    local function has_words_before()
      if vim.bo.buftype == "prompt" then
        return false
      end
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				-- stylua: ignore
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
    end

    return {
      sorting = defaults.sorting,
      experimental = {
        ghost_text = {
          hl_group = "Comment",
        },
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 50 },
        { name = "path", priority = 40 },
        { name = "luasnip", priority = 30 },
      }, {
        { name = "buffer", priority = 50, keyword_length = 3 },
        { name = "emoji", insert = true, priority = 20 },
        {
          name = "tmux",
          priority = 10,
          keyword_length = 3,
          option = { all_panes = true, label = "tmux" },
        },
      }),
      mapping = cmp.mapping.preset.insert({
        -- <CR> accepts currently selected item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<S-CR>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-n>"] = cmp.mapping.select_next_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-p>"] = cmp.mapping.select_prev_item({
          behavior = cmp.SelectBehavior.Insert,
        }),
        ["<C-d>"] = cmp.mapping.select_next_item({ count = 5 }),
        ["<C-u>"] = cmp.mapping.select_prev_item({ count = 5 }),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-c>"] = function(fallback)
          cmp.close()
          fallback()
        end,
        ["<Tab>"] = cmp.mapping(function(fallback)
          local copilot = require("copilot.suggestion")
          if copilot.is_visible() then
            copilot.accept()
          elseif cmp.visible() then
            local entry = cmp.get_selected_entry()
            if not entry then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              cmp.confirm()
            end
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-.>"] = cmp.mapping(function()
          local copilot = require("copilot.suggestion")
          if copilot.is_visible() then
            copilot.next()
          end
        end),
        ["<C-,>"] = cmp.mapping(function()
          local copilot = require("copilot.suggestion")
          if copilot.is_visible() then
            copilot.prev()
          end
        end),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      formatting = {
        format = function(entry, item)
          -- Prepend with a fancy icon from config.
          local icons = require("lazyvim.config").icons
          if entry.source.name == "git" then
            item.kind = icons.misc.git
          else
            local icon = icons.kinds[item.kind]
            if icon ~= nil then
              item.kind = icon .. " " .. item.kind
            end
          end
          return item
        end,
      },
    }
  end,
  ---@param opts cmp.ConfigSchema
  config = function(_, opts)
    for _, source in ipairs(opts.sources) do
      source.group_index = source.group_index or 1
    end
    require("cmp").setup(opts)
  end,
}
