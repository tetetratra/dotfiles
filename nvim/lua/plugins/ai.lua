-- Github Copilot
return {
  {
    "github/copilot.vim",
    config = function()
      vim.api.nvim_set_keymap("i", "<C-f>", "<Plug>(copilot-next)", { silent = true })
      vim.api.nvim_set_keymap("i", "<C-l>", "copilot#Accept('<Right>')", { noremap = true, silent = true, expr = true })
      vim.api.nvim_set_keymap(
        "i",
        "<Right>",
        "copilot#Accept('<Right>')",
        { noremap = true, silent = true, expr = true }
      )
      vim.g.copilot_no_tab_map = true
    end,
  },
}
