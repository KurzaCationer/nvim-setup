return {
    {
        'akinsho/bufferline.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons', 'catppuccin/nvim' },
        config = function()
            require'bufferline'.setup {
                highlights = require'catppuccin.groups.integrations.bufferline'.get(),
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
        end
    }
}
