return {
	{
		'VonHeikemen/lsp-zero.nvim',
		name = 'lsp-zero',
		branch = 'v1.x',
		dependencies = {
			-- LSP Support
			{ 'neovim/nvim-lspconfig' },    -- Required
			{ 'williamboman/mason.nvim' },  -- Optional
			{ 'williamboman/mason-lspconfig.nvim' }, -- Optional
			-- Autocompletion
			{ 'hrsh7th/nvim-cmp' },         -- Required
			{ 'hrsh7th/cmp-nvim-lsp' },     -- Required
			{ 'hrsh7th/cmp-buffer' },       -- Optional
			{ 'hrsh7th/cmp-path' },         -- Optional
			{ 'saadparwaiz1/cmp_luasnip' }, -- Optional
			{ 'hrsh7th/cmp-nvim-lua' },     -- Optional
			{ 'windwp/nvim-autopairs' },
			-- Snippets
			{ 'L3MON4D3/LuaSnip' },    -- Required
			{ 'rafamadriz/friendly-snippets' }, -- Optional
			{ 'ray-x/lsp_signature.nvim' },
			{ 'Decodetalkers/csharpls-extended-lsp.nvim' },
			{ 'nvim-treesitter/nvim-treesitter' }
		},
		config = function()
			local lsp = require 'lsp-zero'

			lsp.preset {
				name = 'recommended',
				set_lsp_keymaps = false,
				manage_nvim_cmp = true,
				suggest_lsp_servers = false,
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

			lsp.configure('csharp_ls', {
				handlers = {
					['textDocument/definition'] = require 'csharpls_extended'.handler,
				},
			})

			lsp.setup_servers({ 'dartls', force = true })

			local allow_format = { 'rust_analyzer', 'csharp_ls', 'null-ls', 'dartls', 'markdownlint' }
			lsp.format_on_save({
				format_opts = {
					timeout_ms = 10000,
				},
				servers = {
					['null-ls'] = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'lua', 'markdown',
						'markdown.mdx' },
					['csharp_ls'] = { 'csharp' },
					['rust_analyzer'] = { 'rust' },
					['dartls'] = { 'dart' },
					['svelte-language-server'] = { 'svelte' },
				}
			})
			lsp.on_attach(function(_, bufnr)
				local opts = function(desc) return { buffer = bufnr, remap = false, desc = desc, silent = true } end
				vim.keymap.set("n", "gD", function() vim.lsp.buf.definition() end, opts('Go to definition'))
				vim.keymap.set("n", "gd", function() vim.lsp.buf.declaration() end, opts('Go to declaration'))
				vim.keymap.set("n", "gi", function() vim.lsp.buf.implementation() end, opts('Go to implementation'))
				vim.keymap.set("n", "gr", "<Cmd>Telescope lsp_references<CR>", opts('Show references'))
				vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts('Hover'))
				vim.keymap.set("n", "<leader>ws", "<Cmd>Telescope lsp_workspace_symbols<CR>", opts('Workspace symbol'))
				vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts('Goto next'))
				vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts('Goto prev'))
				vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts('Code action'))
				vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts('Rename'))
				vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts('Signature Help'))
				vim.keymap.set(
					"n",
					"<leader>fd",
					function()
						vim.lsp.buf.format({
							async = true,
							bufnr = bufnr,
							filter = function(innerClient)
								return vim.tbl_contains(allow_format, innerClient.name)
							end,
							timeout_ms = 10000
						})
					end,
					opts('Format document'))
				vim.keymap.set(
					"v",
					"<leader>fs",
					function()
						vim.lsp.buf.format({
							async = true,
							bufnr = bufnr,
							range = {
								["start"] = vim.api.nvim_buf_get_mark(0, "<"),
								["end"] = vim.api.nvim_buf_get_mark(0, ">"),
							},
							filter = function(innerClient)
								return vim.tbl_contains(allow_format, innerClient.name)
							end,
							timeout_ms = 10000
						})
					end,
					opts('Format selection'))
			end)

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
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"jay-babu/mason-null-ls.nvim",
		},
		opts = {
			sources = {
				-- Anything not supported by mason.
			}
		}
	},
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			'VonHeikemen/lsp-zero.nvim',
		},
		opts = {
			automatic_installation = false,
			handlers = {
				ensure_installed = {
					-- Opt to list sources here, when available in mason.
				},
				automatic_installation = false,
				handlers = {},
			},
		}
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function(_, opts)
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"c",
					"cpp",
					"css",
					"c_sharp",
					"dart",
					"dockerfile",
					"elixir",
					"fish",
					"graphql",
					"go",
					"gomod",
					"html",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"php",
					"python",
					"regex",
					"ruby",
					"rust",
					"scss",
					"sql",
					"svelte",
					"toml",
					"tsx",
					"typescript",
					"vim",
					"wgsl",
					"yaml",
				},
				highlight = { enable = true },
				indent = { enable = true },
				autotag = {
					enable = true,
					filetypes = {
						"html",
						"javascript",
						"javascriptreact",
						"svelte",
						"typescript",
						"typescriptreact",
						"vue",
						"xml",
					},
				},
			})
		end,
	}
}
