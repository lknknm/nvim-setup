return { 
    "nvim-treesitter/nvim-treesitter", 
    branch = 'master', 
    lazy = false, 
    build = ":TSUpdate", 
    config = function()
       require("nvim-treesitter.configs").setup({
           ensure_installed = { "asm", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "cpp" },
           sync_install = false,
           highlight = { enable = true },
           indent = { enable = true }, 
       }) 
    end
}