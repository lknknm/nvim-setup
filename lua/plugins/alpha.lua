return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        dashboard = {
            enabled = true,
            -- Define sections in different panes for a multi-column layout
            sections = {
            {
              section = "terminal",
              cmd = "ascii-image-converter C://Users//LucasMellone//Desktop//Pest-ZoomCrows.jpg -C -c",
              height = 25,
              padding = 1,
            },
            {
              pane = 2,
              { section = "keys", gap = 1, padding = 1 },
              { section = "startup" },
            },
            },
        }
    }
}
