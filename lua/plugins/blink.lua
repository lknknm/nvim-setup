return {
  {
    "saghen/blink.cmp",
    build = 'cargo build --release',
    version = '1.*',
    dependencies = {
      -- Add blink-cmp-unreal as a dependency
      { "taku25/blink-cmp-unreal" },
    },
    opts = {
      sources = {
        -- Enable the "unreal" source
        default = { "lsp", "path", "buffer", "path", "unreal" },
        providers = {
          unreal = {
            module = "blink-cmp-unreal",
            name = "unreal",
            score_offset = 15,
          },
        },
      },
    },
  },
}
