vim.g.mapleader = ","
vim.g.maplocalleader = ","

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
	{
		{
			{
				"ray-x/go.nvim",
				dependencies = { -- optional packages
					"ray-x/guihua.lua",
					"neovim/nvim-lspconfig",
					"nvim-treesitter/nvim-treesitter",
				},
				config = function()
					require("go").setup()
				end,
				event = { "CmdlineEnter" },
				ft = { "go", 'gomod' },
				build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
			},
			{
				'nvim-treesitter/nvim-treesitter',
				build = ":TSUpdate"
			},
			'ray-x/guihua.lua',
			'neovim/nvim-lspconfig',
			'folke/tokyonight.nvim',
			'direnv/direnv.vim',
			{
				'ggandor/leap.nvim',
				dependencies = { 'tpope/vim-repeat' },
				config = function()
					require('leap').add_default_mappings()
				end
			},
			{
				'nvim-telescope/telescope.nvim',
				tag = '0.1.1',
				dependencies = { 'nvim-lua/plenary.nvim' }
			},
			{
				"AckslD/nvim-neoclip.lua",
				dependencies = {
					{ 'nvim-telescope/telescope.nvim' },
				},
				config = function()
					require('neoclip').setup()
				end,
			},
			'gennaro-tedesco/nvim-peekup',
			{
				"nvim-neo-tree/neo-tree.nvim",
				branch = "v2.x",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvim-tree/nvim-web-devicons",
					"MunifTanjim/nui.nvim",
				}
			},
			{
				'rmagatti/auto-session',
				config = function()
					require("auto-session").setup {
						log_level = "error",
						auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
					}
				end
			},
			'rmagatti/session-lens',
			{
				'romgrk/barbar.nvim',
				dependencies = { 'nvim-tree/nvim-web-devicons' },
				init = function() vim.g.barbar_auto_setup = false end,
			},
			{
				"NTBBloodbath/galaxyline.nvim",
				config = function()
					require("galaxyline.themes.spaceline")
				end,
			},
			{
				"kylechui/nvim-surround",
				version = "*", -- Use for stability; omit to use `main` branch for the latest features
				event = "VeryLazy",
				config = function()
					require("nvim-surround").setup({
						-- Configuration here, or leave empty to use defaults
					})
				end
			},
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/nvim-cmp',
			'hrsh7th/vim-vsnip',
			'hrsh7th/cmp-vsnip',
			{
				"mg979/vim-visual-multi",
				branch = "master",
			},
			{
				'numToStr/Comment.nvim',
				config = function()
					require('Comment').setup()
				end
			},
			{
				'folke/trouble.nvim',
				config = function()
					require('trouble').setup()
				end,
			},
		}
	}
)

require("lspconfig").lua_ls.setup {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "space",
					indent_size = "2",
				},
			},
		},
	},
}

require 'nvim-treesitter.configs'.setup {
	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},
}

require 'nvim-treesitter.configs'.setup {
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn", -- set to `false` to disable one of the mappings
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
}

vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
vim.cmd [[colorscheme tokyonight-night]]
vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
vim.cmd [[ set number ]]

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.cmd [[set clipboard+=unnamed,unnamedplus]]

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff',
	"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
	{})
vim.keymap.set('n', '<Space><Space>', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fr', builtin.oldfiles, {})
vim.keymap.set('n', '<leader>op', ':NeoTreeShowToggle<CR>')
vim.keymap.set('c', 'bd', 'BufferClose')

vim.cmd [[
	nnoremap <silent>    <A-,> <Cmd>BufferPrevious<CR>
	nnoremap <silent>    <A-.> <Cmd>BufferNext<CR>
	nnoremap <silent>    <A-c> <Cmd>BufferClose<CR>
	nnoremap <silent>    <A-s-c> <Cmd>BufferRestore<CR>
	nnoremap <silent> <C-p>    <Cmd>BufferPick<CR>
	nnoremap <silent> <C-p>    <Cmd>BufferPickDelete<CR>
]]

vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
		vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
		vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set('n', '<space>wl', function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})

local cmp = require 'cmp'

cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
	}),
	sources = cmp.config.sources(
		{
			{ name = 'nvim_lsp' },
			{ name = 'vsnip' },
		},
		{
			{ name = 'buffer' },
		}
	)
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	}, {
		{ name = 'cmdline' }
	})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
require('lspconfig')['gopls'].setup {
	capabilities = capabilities
}

local format_sync_grp = vim.api.nvim_create_augroup("GoImport", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require('go.format').goimport()
	end,
	group = format_sync_grp,
})