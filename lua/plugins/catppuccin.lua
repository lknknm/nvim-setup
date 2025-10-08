return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "mocha", -- Auto-applies Catppuccin Mocha
        transparent_background = true, -- THIS IS REQUIRED
        show_end_of_buffer = false, -- Optional: Disable weird ~ marks
        term_colors = true, -- Ensure terminal colors match theme
        integrations = { ... }, -- Keep your existing integrations (if any)
    },
    config = function(_, opts)
        -- Apply transparency tweaks
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")

        -- (Optional) Force other highlights to be transparent (if theme doesn't set them)
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end
}
