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
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = { "copilot.vim", "plenary.nvim" },
    config = function()
      local select = require("CopilotChat.select")
      require("CopilotChat").setup({
        debug = true,
        highlight_selection = false,
        show_help = true,
        mappings = {
          accept_diff = { normal = "Y" },
          reset = { normal = "R" },
        },
        window = { width = 0.3 },
      })
      function CopilotChatBuffer()
        require("CopilotChat").toggle({
          selection = function(source)
            return select.visual(source) or select.buffer(source)
          end,
        })
      end
      vim.api.nvim_set_keymap("n", "<F3>", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("v", "<F3>", "<cmd>lua CopilotChatBuffer()<cr>", { noremap = true, silent = true })
      function ShowCopilotChatActionPrompt()
        local actions = require("CopilotChat.actions")
        require("CopilotChat.integrations.telescope").pick(actions.prompt_actions(), { initial_mode = "normal" })
      end
      vim.api.nvim_set_keymap(
        "n",
        "<Leader>C",
        "<cmd>lua ShowCopilotChatActionPrompt()<cr>",
        { noremap = true, silent = true }
      )
    end,
  },
}
