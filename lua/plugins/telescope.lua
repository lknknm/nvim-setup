return { 
    "nvim-telescope/telescope.nvim", 
    tag = "0.1.5", 
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
	    local builtin = require("telescope.builtin")
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fw', builtin.live_grep, {})

        require("telescope").setup()

        local layout_strategies = require('telescope.pickers.layout_strategies')
        local original_horizontal = layout_strategies.horizontal

        layout_strategies.horizontal = function(self, ...)
          self.prompt_title = ""
          self.results_title = ""
          self.preview_title = ""
          return original_horizontal(self, ...)
        end

        layout_strategies.vertical = function(self, ...)
          self.prompt_title = ""
          self.results_title = ""
          self.preview_title = ""
          return layout_strategies.vertical(self, ...)
        end
    end
}
