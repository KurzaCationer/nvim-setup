return {
    {
        'nvim-neo-tree/neo-tree.nvim',
        name = 'neo-tree',
        dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons', 'MunifTanjim/nui.nvim' },
        keys = {
            { '<leader>ft', '<cmd>Neotree toggle<cr>', desc = 'NeoTree' },
        },
		config = function()
			vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
			require 'neo-tree'.setup {
				nesting_rules = {},
				filesystem = {
					filtered_items = {
						visible = true
					}
				}
			}
		end
    }
}
