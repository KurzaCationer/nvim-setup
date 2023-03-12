return {
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        priority = 1000,
        config = function()
            require'catppuccin'.setup {
                flavour = "mocha",
                integrations = {
                    cmp = true,
                    treesitter = true,
                    native_lsp = {
                        enabled = true,
                        styles = {
                            errors = "italic",
                            hints = "italic",
                            warnings = "italic",
                            information = "italic",
                        },
                    },
                    lsp_trouble = true,
                    telescope = true,
                    bufferline = true,
                    markdown = true,
                    mason = true,
                    neotree = true,
                    dap = true,
                    which_key = true,
                    -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
                },
            }
            vim.cmd([[colorscheme catppuccin]])
        end,
    },
}
