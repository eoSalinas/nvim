return {
    {
        "saghen/blink.cmp",
        version = "*",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
            keymap = {
                preset = "default",
                ["<C-k>"] = {
                    function(cmp)
                        if cmp.is_documentation_visible() then
                            return cmp.hide_documentation()
                        else
                            return cmp.show_documentation()
                        end
                    end,
                    "fallback",
                },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono",
            },
            sources = {
                default = { "lazydev", "lsp", "path", "snippets", "buffer" },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            completion = {
                documentation = {
                    auto_show = false,
                },
            },
        },
    },
}
