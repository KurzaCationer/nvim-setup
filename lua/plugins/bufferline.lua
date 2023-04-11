return {
    {
        'akinsho/bufferline.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'catppuccin/nvim' },
        config = function(_, opts)
            opts.highlights = require 'catppuccin.groups.integrations.bufferline'.get()
            require 'bufferline'.setup(opts)
        end,
        opts = {
            options = {
                offsets = {
                    {
                        filetype = "neo-tree",
                        text = "File Explorer",
                        separator = true,
                    }
                }
            }
        }
    }
}
