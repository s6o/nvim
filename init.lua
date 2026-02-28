if vim.g.vscode ~= nil then
-- do not configure for VSCode
else
	--------------------------------------------------------------------------------
	-- OPTIONS
	--------------------------------------------------------------------------------
	vim.opt.termguicolors = true
	vim.cmd.colorscheme("habamax")

	vim.opt.number = true -- line number
	vim.opt.relativenumber = true -- relative line numbers
	vim.opt.cursorline = true -- highlight current line
	vim.opt.wrap = false -- do not wrap lines by default
	vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
	vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor

	vim.opt.tabstop = 2 -- tab width
	vim.opt.shiftwidth = 2 -- indent width
	vim.opt.softtabstop = 2 -- soft tab stop, not tabs on tab/backspace
	vim.opt.expandtab = true -- use spaces instead of tabs
	vim.opt.smartindent = true -- smart auto-indent
	vim.opt.autoindent = true -- copy indent from current line

	vim.opt.ignorecase = true -- case-insensitive search
	vim.opt.smartcase = true -- case sensitive if uppercase in string
	vim.opt.hlsearch = true -- highlight search matches
	vim.opt.incsearch = true -- show matches as you type

	vim.opt.signcolumn = "yes" -- always show a sign column
	vim.opt.colorcolumn = "80" -- show a column at 100 postion chars
	vim.opt.showmatch = true -- highlight matching brackets
	vim.opt.cmdheight = 1 -- single line command line
	vim.opt.completeopt = "menuone,noinsert,noselect"
	vim.opt.showmode = false -- do not show the mode, instead have it in statusline
	vim.opt.pumheight = 10 -- popup menu height
	vim.opt.pumblend = 10 -- popup menu transparency
	vim.opt.winblend = 0 -- floating window transparency
	vim.opt.conceallevel = 0 -- do not hide markup
	vim.opt.lazyredraw = true -- do not redraw during macros
	vim.opt.synmaxcol = 300 -- syntax highlight limit
	vim.opt.fillchars = { eob = " " } -- hide "~" on empty lines

	local undodir = vim.fn.expand("~/.config/nvim/undodir")
	if
		vim.fn.isdirectory(undodir) == 0 -- create undodir if non-existent
	then
		vim.fn.mkdir(undodir, "p")
	end

	vim.opt.backup = false -- do not crate a backup file
	vim.opt.writebackup = false -- do not write a backup file
	vim.opt.swapfile = false -- do not create a swap (.swp) file
	vim.opt.undofile = true
	vim.opt.undodir = undodir
	vim.opt.updatetime = 300 -- faster completion
	vim.opt.timeoutlen = 500 -- timeout duration for mapped sequence
	vim.opt.ttimeoutlen = 0 -- key code timeout
	vim.opt.autoread = true -- auto-reload changes if outside of neovim
	vim.opt.autowrite = false -- do not auto-save

	vim.opt.hidden = true -- allow hidden buffers
	vim.opt.errorbells = false
	vim.opt.backspace = "indent,eol,start"
	vim.opt.autochdir = false -- do not auto-change directories
	vim.opt.iskeyword:append("-") -- include (-) hyphen in words
	vim.opt.path:append("**") -- include sub-directories in search
	vim.opt.selection = "inclusive" -- include last char in selection
	vim.opt.mouse = "a" -- enable mouse support
	--vim.opt.clipboard:append("unnamedplus")
	vim.opt.modifiable = true -- allow buffer modifications
	vim.opt.encoding = "UTF-8"

	--vim.opt.guicursor = "n-v-c:block,i-ci-ve:block,r-cr:hor20,o:hor50,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor,sm:block-blinkwait175-blinkoff150-blinkon175"

	vim.opt.foldmethod = "expr" -- use expression for folding
	vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	vim.opt.foldlevel = 99

	vim.opt.splitbelow = true -- horizontal splits go below
	vim.opt.splitright = true -- vertical splits go right

	vim.opt.wildmenu = true -- tab completion
	vim.opt.wildmode = "longest:full,full"
	vim.opt.diffopt:append("linematch:60")
	vim.opt.redrawtime = 10000
	vim.opt.maxmempattern = 20000

	--------------------------------------------------------------------------------
	-- STATUSLINE
	--------------------------------------------------------------------------------

	local cached_branch = ""
	local last_check = 0
	local function git_branch()
		local now = vim.loop.now()
		if now - last_check > 5000 then
			cached_branch = vim.fn.system("git branch --show-current 2>/dev/null | tr -d '\n'")
			last_check = now
		end
		if cached_branch ~= "" then
			return " \u{e725} " .. cached_branch .. " "
		end
		return ""
	end

	local function file_type()
		local ft = vim.bo.filetype
		local icons = {
			bash = "\u{f489} ",
			c = "\u{e61e} ",
			cpp = "\u{e61d} ",
			css = "\u{e749} ",
			dart = "\u{e798} ",
			dockerfile = "\u{f308} ",
			elixir = "\u{e62d} ",
			gitcommit = "\u{f418} ",
			gitconfig = "\u{f1d3} ",
			go = "\u{e724} ",
			haskell = "\u{e777} ",
			html = "\u{e736} ",
			java = "\u{e738} ",
			javascript = "\u{e74e} ",
			javascriptreact = "\u{e7ba} ",
			json = "\u{e60b} ",
			kotlin = "\u{e634} ",
			lua = "\u{e620} ",
			markdown = "\u{e73e} ",
			php = "\u{e73d} ",
			python = "\u{e73c} ",
			ruby = "\u{e739} ",
			rust = "\u{e7a8} ",
			scss = "\u{e749} ",
			sh = "\u{f489} ",
			sql = "\u{e706} ",
			swift = "\u{e755} ",
			toml = "\u{e615} ",
			typescript = "\u{e628} ",
			typescriptreact = "\u{e7ba} ",
			vim = "\u{e62b} ",
			xml = "\u{f05c} ",
			yaml = "\u{f481} ",
			zsh = "\u{f489} ",
		}

		if ft == "" then
			return " \u{f15b} "
		end

		return ((icons[ft] or " \u{f15b} ") .. ft)
	end

	local function file_size()
		local size = vim.fn.getfsize(vim.fn.expand("%"))
		if size < 0 then
			return ""
		end
		local size_str
		if size < 1024 then
			size_str = size .. "B"
		elseif size < 1024 * 1024 then
			size_str = string.format("%.1fK", size / 1024)
		else
			size_str = string.format("%.1fM", size / 1024 / 1024)
		end
		return " \u{f016} " .. size_str .. " "
	end

	local function mode_icon()
		local mode = vim.fn.mode()
		local modes = {
			n = " \u{f121}  NORMAL",
			i = " \u{f11c}  INSERT",
			v = " \u{f0168} VISUAL",
			V = " \u{f0168} V-LINE",
			["\22"] = " \u{f0168} V-BLOCK",
			c = " \u{f120} COMMAND",
			s = " \u{f0c5} SELECT",
			S = " \u{f0c5} S-LINE",
			["\19"] = " \u{f0c5} S-BLOCK",
			R = " \u{f044} REPLACE",
			r = " \u{f044} REPLACE",
			["!"] = " \u{f489} SHELL",
			t = " \u{f120} TERMINAL",
		}
		return modes[mode] or (" \u{f059} " .. mode)
	end

	_G.mode_icon = mode_icon
	_G.git_branch = git_branch
	_G.file_type = file_type
	_G.file_size = file_size

	vim.cmd([[
  highlight StatusLineBold gui=bold cterm=bold
]])

	local function setup_dynamic_statusline()
		vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
			callback = function()
				vim.opt_local.statusline = table.concat({
					" ",
					"%#StatusLineBold#",
					"%{v:lua.mode_icon()}",
					"%#StatusLine#",
					" \u{e0b1} %f %h%m%r",
					"%{v:lua.git_branch()}",
					"\u{e0b1} ",
					"%{v:lua.file_type()}",
					"\u{e0b1} ",
					"%{v:lua.file_size()}",
					"%=",
					" \u{f017} %l:%c  %P ",
				})
			end,
		})
		vim.api.nvim_set_hl(0, "StatusLineBold", { bold = true })
		vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
			callback = function()
				vim.opt_local.statusline = " %f %h%m%r \u{e0b1} %{v:lua.file_type()} %= %l:%c  %P "
			end,
		})
	end

	setup_dynamic_statusline()

	--------------------------------------------------------------------------------
	-- GENERAL KEYMAPS
	--------------------------------------------------------------------------------
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

	vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
	vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

	vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
	vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
	vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
	vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

	vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split window vertically" })
	vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split window horizontally" })
	vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
	vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
	vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
	vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

	vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
	vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
	vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
	vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

	vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
	vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

	vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
	vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

	vim.keymap.set("n", "<leader>pa", function()
		local path = vim.fn.expand("%:p")
		vim.fn.setreg("+", path)
		print("file:", path)
	end, { desc = "Copy full file path" })

	vim.keymap.set("n", "<leader>td", function()
		vim.diagnostic.enable(not vim.diagnostic.is_enabled())
	end, { desc = "Toggle diagnostics" })

	--------------------------------------------------------------------------------
	-- RESTORE LAST CURSOR POSITION
	--------------------------------------------------------------------------------

	vim.api.nvim_create_autocmd({ "BufReadPost" }, {
		desc = "Restore last cursor position",
		callback = function()
			if vim.o.diff then
				return
			end

			local last_pos = vim.api.nvim_buf_get_mark(0, '"')
			local last_line = vim.api.nvim_buf_line_count(0)

			local row = last_pos[1]
			if row < 1 or row > last_line then
				return
			end

			pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
		end,
	})

	--------------------------------------------------------------------------------
	-- PLUGINS
	--------------------------------------------------------------------------------
	vim.pack.add({
		"https://www.github.com/nvim-tree/nvim-tree.lua",
		"https://github.com/nvim-tree/nvim-web-devicons.git",
		"https://www.github.com/ibhagwan/fzf-lua",
		"https://www.github.com/echasnovski/mini.nvim",
		"https://www.github.com/lewis6991/gitsigns.nvim",
		{
			src = "https://github.com/nvim-treesitter/nvim-treesitter",
			branch = "main",
			build = ":TSUpdate",
		},
		"https://www.github.com/neovim/nvim-lspconfig",
		"https://github.com/mason-org/mason.nvim",
		"https://github.com/creativenull/efmls-configs-nvim",
		{
			src = "https://github.com/saghen/blink.cmp",
			version = vim.version.range("1.*"),
		},
		"https://github.com/L3MON4D3/LuaSnip",
	})

	local function packadd(name)
		vim.cmd("packadd " .. name)
	end

	packadd("nvim-tree.lua")
	packadd("nvim-web-devicons")
	packadd("fzf-lua")
	packadd("mini.nvim")
	packadd("gitsigns.nvim")
	packadd("nvim-tree.lua")
	packadd("nvim-lspconfig")
	packadd("mason.nvim")
	packadd("efmls-configs-nvim")
	packadd("blink.cmp")
	packadd("LuaSnip")

	-- SETUP: nvim-tree
	require("nvim-tree").setup({
		view = { width = 35 },
		filters = { dotfiles = false },
		renderer = { group_empty = true },
	})
-- stylua: ignore
vim.keymap.set("n", "<leader>e", function() require("nvim-tree.api").tree.toggle() end, { desc = "Toggle nvim-tree" })
	vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
	vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
	vim.api.nvim_set_hl(0, "NvimTreeSignColumn", { bg = "none" })
	vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { fg = "#2a2a2a", bg = "none" })
	vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

	-- SETUP: nvim-tree icons
	require("nvim-web-devicons").setup({})

	-- SETUP: fzf-lua
	require("fzf-lua").setup({})
-- stylua: ignore start
vim.keymap.set("n", "<leader>ff", function() require("fzf-lua").files() end, { desc = "FZF Files" })
vim.keymap.set("n", "<leader>fg", function() require("fzf-lua").live_grep() end, { desc = "FZF Live Grep" })
vim.keymap.set("n", "<leader>fb", function() require("fzf-lua").buffers() end, { desc = "FZF Buffers" })
vim.keymap.set("n", "<leader>fh", function() require("fzf-lua").help_tags() end, { desc = "FZF Help Tags" })
vim.keymap.set("n", "<leader>fx", function() require("fzf-lua").diagnostics_document() end, { desc = "FZF Diagnostics Document" })
vim.keymap.set("n", "<leader>fX", function() require("fzf-lua").diagnostics_workspace() end, { desc = "FZF Diagnostics Workspace" })
	-- stylua: ignore end

	-- SETUP: mini.nvim
	require("mini.ai").setup({})
	require("mini.comment").setup({})
	require("mini.move").setup({})
	require("mini.surround").setup({})
	require("mini.cursorword").setup({})
	require("mini.indentscope").setup({})
	require("mini.pairs").setup({})
	require("mini.trailspace").setup({})
	require("mini.bufremove").setup({})
	require("mini.notify").setup({})
	require("mini.icons").setup({})

	-- SETUP: gitsigns.nvim
	require("gitsigns").setup({
		signs = {
			add = { text = "\u{2590}" }, -- ▏
			change = { text = "\u{2590}" }, -- ▐
			delete = { text = "\u{2590}" }, -- ◦
			topdelete = { text = "\u{25e6}" }, -- ◦
			changedelete = { text = "\u{25cf}" }, -- ●
			untracked = { text = "\u{25cb}" }, -- ○
		},
		signcolumn = true,
		current_line_blame = false,
	})
-- stylua: ignore start
vim.keymap.set("n", "<leader>hn", function() require("gitsigns").next_hunk() end, { desc = "Next git hunk" })
vim.keymap.set("n", "<leader>hp", function() require("gitsigns").prev_hunk() end, { desc = "Previous git hunk" })
vim.keymap.set("n", "<leader>hs", function() require("gitsigns").stage_hunk() end, { desc = "Stage git hunk" })
vim.keymap.set("n", "<leader>hr", function() require("gitsigns").reset_hunk() end, { desc = "Reset git hunk" })
vim.keymap.set("n", "<leader>hp", function() require("gitsigns").preview_hunk() end, { desc = "Preview git hunk" })
vim.keymap.set("n", "<leader>hb", function() require("gitsigns").blame_line({ full = true }) end, { desc = "Blame line" })
vim.keymap.set("n", "<leader>hB", function() require("gitsigns").toggle_current_line_blame({ full = true }) end, { desc = "Toggle inline blame" })
vim.keymap.set("n", "<leader>hd", function() require("gitsigns").diffthis() end, { desc = "Diff this" })
-- stylua: ignore start

-- SETUP: nvim-treesitter
local setup_treesitter = function()
	local treesitter = require("nvim-treesitter")
	treesitter.setup({})
	local ensure_installed = {
		"lua",
		"vim",
		"vimdoc",
	}

	local config = require("nvim-treesitter.config")

	local already_installed = config.get_installed()
	local parsers_to_install = {}

	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(parsers_to_install, parser)
		end
	end

	if #parsers_to_install > 0 then
		treesitter.install(parsers_to_install)
	end

	local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		callback = function(args)
			if vim.list_contains(treesitter.get_installed(), vim.treesitter.language.get_lang(args.match)) then
				vim.treesitter.start(args.buf)
			end
		end,
	})
end

setup_treesitter()

-- SETUP: mason
require("mason").setup({})

-- SETUP: Diagnostics for LSP, Linters, Formatters
local diagnostic_signs = {
	Error = " ",
	Warn = " ",
	Hint = "",
	Info = "",
}

vim.diagnostic.config({
	virtual_text = { prefix = "●", spacing = 4 },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
			[vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
			[vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
			[vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true, --"always",
		header = "",
		prefix = "",
		focusable = false,
		style = "minimal",
	},
})

do
	local orig = vim.lsp.util.open_floating_preview
	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		return orig(contents, syntax, opts, ...)
	end
end

-- SETUP: LSP, Linters, Formatters
local function lsp_on_attach(ev)
	local client = vim.lsp.get_client_by_id(ev.data.client_id)
	if not client then
		return
	end

	local bufnr = ev.buf
	local opts = { noremap = true, silent = true, buffer = bufnr }

  -- stylua: ignore start
	vim.keymap.set("n", "<leader>gd", function() require("fzf-lua").lsp_definitions({ jump_to_single_result = true }) end, opts)
	vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "<leader>gS", function() vim.cmd("vsplit") vim.lsp.buf.definition() end, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>D", function() vim.diagnostic.open_float({ scope = "line" }) end, opts)
	vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float({ scope = "cursor" }) end, opts)
	vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.jump({ count = 1 }) end, opts)
	vim.keymap.set("n", "<leader>pd", function() vim.diagnostic.jump({ count = -1 }) end, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>fd", function() require("fzf-lua").lsp_definitions({ jump_to_single_result = true }) end, opts)
	vim.keymap.set("n", "<leader>fr", function() require("fzf-lua").lsp_references() end, opts)
	vim.keymap.set("n", "<leader>ft", function() require("fzf-lua").lsp_typedefs() end, opts)
	vim.keymap.set("n", "<leader>fs", function() require("fzf-lua").lsp_document_symbols() end, opts)
	vim.keymap.set("n", "<leader>fw", function() require("fzf-lua").lsp_workspace_symbols() end, opts)
	vim.keymap.set("n", "<leader>fi", function() require("fzf-lua").lsp_implementations() end, opts)
  -- stylua: ignore start

	if client:supports_method("textDocument/codeAction", bufnr) then
		vim.keymap.set("n", "<leader>oi", function()
			vim.lsp.buf.code_action({
				context = { only = { "source.organizeImports" }, diagnostics = {} },
				apply = true,
				bufnr = bufnr,
			})
			vim.defer_fn(function()
				vim.lsp.buf.format({ bufnr = bufnr })
			end, 50)
		end, opts)
	end
end

vim.api.nvim_create_autocmd("LspAttach", { callback = lsp_on_attach })

-- stylua: ignore start
vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist({ open = true }) end, { desc = "Open diagnostic list" })
vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })
	-- stylua: ignore end
	--
	--
	--
	vim.lsp.config("lua_ls", {
		settings = {
			Lua = {
				diagnostics = { globals = { "vim" } },
				telemetry = { enable = false },
			},
		},
	})

	do
		local luacheck = require("efmls-configs.linters.luacheck")
		local stylua = require("efmls-configs.formatters.stylua")
		vim.lsp.config("efm", {
			filetypes = {
				"lua",
			},
			init_options = { documentFormatting = true },
			settings = {
				languages = {
					lua = { luacheck, stylua },
				},
			},
		})
	end

	vim.lsp.enable({
		"efm",
		"lua_ls",
	})

	-- format on save via efm
	vim.api.nvim_create_autocmd({ "BufWritePre" }, {
		pattern = {
			"*.lua",
		},
		callback = function(args)
			-- avoid formatting non-file buffers
			if vim.bo[args.buf].buftype ~= "" then
				return
			end
			if not vim.bo[args.buf].modifiable then
				return
			end
			if vim.api.nvim_buf_get_name(args.buf) == "" then
				return
			end

			local has_efm = false
			for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
				if c.name == "efm" then
					has_efm = true
					break
				end
			end
			if not has_efm then
				return
			end

			pcall(vim.lsp.buf.format, {
				bufnr = args.buf,
				timeout_ms = 2000,
				filter = function(c)
					return c.name == "efm"
				end,
			})
		end,
	})

	-- SETUP: blink with LuaSnip
	require("blink.cmp").setup({
		keymap = {
			preset = "none",
			["<C-Space>"] = { "show", "hide" },
			["<CR>"] = { "accept", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<Tab>"] = { "snippet_forward", "fallback" },
			["<S-Tab>"] = { "snippet_backward", "fallback" },
		},
		appearance = { nerd_font_variant = "mono" },
		completion = { menu = { auto_show = true } },
		sources = { default = { "lsp", "path", "buffer", "snippets" } },
		snippets = {
			expand = function(snippet)
				require("luasnip").lsp_expand(snippet)
			end,
		},

		fuzzy = {
			implementation = "prefer_rust",
			prebuilt_binaries = { download = true },
		},
	})

	vim.lsp.config["*"] = {
		capabilities = require("blink.cmp").get_lsp_capabilities(),
	}
end
