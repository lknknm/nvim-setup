return { 
    "nvim-treesitter/nvim-treesitter-context", 
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("treesitter-context").setup({
            enable = true,
            max_lines = 1,

            min_window_height = 5,
            mode = 'topline',
            separator = '─',
            -- markdown's fenced-code-block injections trigger a Neovim 0.12+
            -- core treesitter bug (conceal_lines predicate calls node:range()
            -- on nil): https://github.com/neovim/neovim/issues/39032
            on_attach = function(buf)
                return vim.bo[buf].filetype ~= "markdown"
            end,
        })
    end
}
