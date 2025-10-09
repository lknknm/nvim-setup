return {
    {
        "tpope/vim-fugitive",
        vim.keymap.set('n', '<leader>gb', ':Git blame<CR>', { desc = 'Git blame' })
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup()
        end
    }
}
