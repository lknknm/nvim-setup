return { 
    'nvim-mini/mini.indentscope', 
    version = '*', 
    config = function()
        require('mini.indentscope').setup({
            draw = {
                delay = 10,
                animation = function(s,n)
                    return 2
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
}
