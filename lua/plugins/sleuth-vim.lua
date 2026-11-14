return {
    "tpope/vim-sleuth",
    event = { "BufReadPre", "BufNewFile" },
    -- No further initialization needed, as this is a real "vim" not a lua
    -- plugin.
}
