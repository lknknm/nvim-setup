return {
    {
        'nvim-mini/mini.indentscope', 
        version = '*', 
        config = function()
            require('mini.indentscope').setup({
                draw = {
                    delay = 10,
                    animation = function(s,n)
                        return 0.5
                    end,
                },
                opts = {
                    border = 'both',
                    indent_at_cursor = true,
                    n_lines = 10000,
                    try_as_border = true,
                },
                symbol = "│",
            })
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
        config = function ()
            require("ibl").setup({
                scope = { enabled = false },
                indent = { char = "│" },
            })
        end
    }
}

