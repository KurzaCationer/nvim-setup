return {
    {
        'VonHeikemen/lsp-zero.nvim',
		name = 'lsp-zero',
        branch = 'v1.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },             -- Required
            { 'williamboman/mason.nvim' },           -- Optional
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },                  -- Required
            { 'hrsh7th/cmp-nvim-lsp' },              -- Required
            { 'hrsh7th/cmp-buffer' },                -- Optional
            { 'hrsh7th/cmp-path' },                  -- Optional
            { 'saadparwaiz1/cmp_luasnip' },          -- Optional
            { 'hrsh7th/cmp-nvim-lua' },              -- Optional
            { 'windwp/nvim-autopairs' },
            -- Snippets
            { 'L3MON4D3/LuaSnip' },             -- Required
            { 'rafamadriz/friendly-snippets' }, -- Optional
            { 'ray-x/lsp_signature.nvim' },
        },
        config = function()
            local lsp = require 'lsp-zero'

            lsp.preset {
                name = 'recommended'
            }

            local cmp = require 'cmp'
            lsp.setup_nvim_cmp({
                preselect = cmp.PreselectMode.None,
                completion = {
                    completeopt = 'menu,menuone,noinsert,noselect'
                },
            })

            require 'lsp_signature'.setup {}

            lsp.configure('lua_ls', {
                settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                            version = 'LuaJIT',
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { 'vim' },
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files
                            library = vim.api.nvim_get_runtime_file('', true),
                            checkThirdParty = false,
                        },
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = {
                            enable = false,
                        },
                    }
                }
            })

            lsp.nvim_workspace()

            lsp.setup()

            vim.diagnostic.config({
                virtual_text = true
            })
        end
    },
	{
		'windwp/nvim-autopairs',
		name = 'autopairs',
		dependencies = { 'hrsh7th/nvim-cmp' },
		config = function()
			local cmp = require 'cmp'
			require 'nvim-autopairs'.setup()
            local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

            cmp.event:on(
            	'confirm_done',
            	cmp_autopairs.on_confirm_done({ map_char = { tex = "" } })
            )
		end
	}
}
