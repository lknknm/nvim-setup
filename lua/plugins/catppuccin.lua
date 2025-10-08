return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        transparent_background = true, 
        show_end_of_buffer = false,
        term_colors = true, 
        integrations = {
            gitsigns = true,
            telescope = true,
        },
    },

    config = function(_, opts)
        -- Apply transparency tweaks
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")

        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        
        -- transparent background
        vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'TelescopeBorder', { link = "Function"  })
        vim.api.nvim_set_hl(0, 'TelescopeTitle', { bg = 'none' })
    end
}
