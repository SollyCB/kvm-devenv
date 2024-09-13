vim.keymap.set('n', '>', '>>')
vim.keymap.set('n', '<', '<<')
vim.keymap.set('n', '<space>w', ':w<cr>')

vim.cmd([[
	set grepprg=rg\ --vimgrep
	command! -nargs=+ Grep execute 'silent grep! <args>' | copen 42
]])

vim.opt.guicursor  = ""
vim.opt.wrap       = false
vim.opt.splitright = true

vim.cmd.highlight({"ExtraWhitespace", "ctermbg=lightblue", "guibg=lightblue"})
vim.cmd.highlight({"Visual", "ctermbg=darkgrey", "guibg=darkgrey"})

vim.cmd([[
	highlight ExtraWhitespace ctermbg=darkred guibg=darkred
    	match ExtraWhitespace /\s\+$/
    	autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    	autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    	autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    	autocmd BufWinLeave * call clearmatches()
]])

vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	pattern = {"*.c", "*.h"},
  	callback = function()
		vim.opt_local.colorcolumn = "81"
		vim.opt_local.tabstop     = 8
		vim.opt_local.shiftwidth  = 8
		vim.opt_local.softtabstop = 0
		vim.opt_local.expandtab   = false
	end
})

require('packer').startup(function()
	use 'wbthomason/packer.nvim'
	use 'jremmen/vim-ripgrep'
	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
end)

local opts = { noremap=true, silent=true }

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	client.server_capabilities.semanticTokensProvider = nil

	local function on_list(options)
		vim.fn.setqflist({}, ' ', options)
		vim.api.nvim_command('copen 40')
	end

	local bufopts = { noremap=true, silent=true, buffer=bufnr }

	vim.keymap.set('i', '<c-n>', '<c-x><c-o>', bufopts)

	vim.keymap.set('n', 'K',         vim.lsp.buf.hover,           bufopts)
	vim.keymap.set('n', 'gd',        vim.lsp.buf.definition,      bufopts)
	vim.keymap.set('n', 'gi',        vim.lsp.buf.implementation,  bufopts)
	vim.keymap.set('n', 'gr',        vim.lsp.buf.references,      bufopts)
	vim.keymap.set('n', 'gD',        vim.lsp.buf.declaration,     bufopts)
	vim.keymap.set('n', '<space>K',  vim.lsp.buf.signature_help,  bufopts)
	vim.keymap.set('n', 'gt',        vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<F2>',      vim.lsp.buf.rename,          bufopts)
	vim.keymap.set('n', '<space>r',  vim.lsp.buf.rename,          bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action,     bufopts)
	vim.keymap.set('n', '<space>e',  vim.diagnostic.open_float,   opts)
	vim.keymap.set('n', '[d',        vim.diagnostic.goto_prev,    opts)
	vim.keymap.set('n', ']d',        vim.diagnostic.goto_next,    opts)
end

require('lspconfig').clangd.setup({ on_attach = on_attach })

vim.diagnostic.config({ virtual_text = false; signs=false; underline=false; })

require('telescope').setup({ defaults = { preview = { treesitter = false } }, pickers = { diagnostics = {bufnr = 0} } })

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<space>f', builtin.find_files,  {})
vim.keymap.set('n', '<space>g', builtin.live_grep,   {})
vim.keymap.set('n', '<space>b', builtin.buffers,     {})
vim.keymap.set('n', '<space>h', builtin.help_tags,   {})
vim.keymap.set('n', '<space>d', builtin.diagnostics, {})
