-- for disabling built-in LazyVim plugins
return {
  -- disable bufferline.nvim
  { "akinsho/bufferline.nvim", enabled = false },

  -- disable enter to autocomplete
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.mapping["<CR>"] = nil
    end,
  },

  -- disable noice.nvim cmdline replacement
  { "folke/noice.nvim", enabled = false },

  -- disable rust_analyzer configuration for lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
  },
}
