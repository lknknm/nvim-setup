return {
  {
    "Saghen/blink.cmp",
    build = 'cargo build --release',
    version = '*',
    dependencies = {
      -- Add blink-cmp-unreal as a dependency
      { "taku25/blink-cmp-unreal" },
    },
    opts = {
      sources = {
        -- Enable the "unreal" source
        default = { "lsp", "buffer", "path", "unreal" },
        providers = {
          unreal = {
            module = "blink-cmp-unreal",
            name = "unreal",
            -- Adjust the score if you want to prioritize it over LSP
            score_offset = 15,
          },
        },
      },
      --... other blink.cmp settings
    },
  },
}
