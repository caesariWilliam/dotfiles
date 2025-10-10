-- vim-plug bootstrap
local vim = vim
local Plug = vim.fn['plug#']

if vim.fn.empty(vim.fn.glob(vim.fn.stdpath('data') .. '/site/autoload/plug.vim')) == 1 then
    vim.fn.system({'curl', '-fLo', vim.fn.stdpath('data') .. '/site/autoload/plug.vim', '--create-dirs', 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'})
end

-- Plugins
vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')
Plug('catppuccin/nvim', {as = 'catppuccin'})
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
Plug('junegunn/fzf.vim')
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')
Plug('tpope/vim-fugitive')
Plug('tpope/vim-commentary')
Plug('neovim/nvim-lspconfig')
Plug('williamboman/mason.nvim')
Plug('williamboman/mason-lspconfig.nvim')
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('ms-jpq/coq_nvim', {branch = 'coq'})
Plug('ms-jpq/coq.artifacts', {branch = 'artifacts'})
Plug('lewis6991/gitsigns.nvim')
Plug('romgrk/barbar.nvim')
Plug('folke/which-key.nvim')

vim.call('plug#end')

-- Basic settings
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true

-- Auto-reload files when changed outside vim
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})

-- Always edit files, never open read-only
vim.opt.readonly = false
vim.opt.modifiable = true
vim.opt.shortmess:append('A') -- Never show "ATTENTION" message when file is already open elsewhere

-- Highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})

-- FZF configuration to ignore directories
vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*" --glob "!.venv/*" --glob "!.hatch/*" --glob "!.ruff_cache/*" --glob "!.mypy_cache/*"'

-- Directories
local state_dir = vim.fn.stdpath('state')
vim.opt.directory = state_dir .. '/swap//'
vim.opt.backupdir = state_dir .. '/backup//'
vim.opt.undodir = state_dir .. '/undo//'

local function ensure_dir(path)
    if vim.fn.isdirectory(path) == 0 then
        vim.fn.mkdir(path, 'p')
    end
end
ensure_dir(vim.opt.directory:get()[1])
ensure_dir(vim.opt.backupdir:get()[1])
ensure_dir(vim.opt.undodir:get()[1])




-- Keymaps
vim.keymap.set('n', '<leader>f', ':Files<CR>')
vim.keymap.set('n', '<C-S-f>', ':Rg<CR>')
vim.keymap.set('n', '<leader>bd', ':confirm bdelete<CR>')
vim.keymap.set('n', '<S-h>', ':bprev<CR>')
vim.keymap.set('n', '<S-l>', ':bnext<CR>')

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')


-- Close window with leader wq
vim.keymap.set('n', '<leader>wq', ':q<CR>', { noremap = true, silent = true })

-- LSP keymaps
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gr', vim.lsp.buf.references, { noremap = true, silent = true })

-- Git keymaps
vim.keymap.set('n', '<leader>gb', ':Git blame --date=relative<CR>', { noremap = true, silent = true })

-- Search keymaps
vim.keymap.set('n', '<leader>sa', ':Rg<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>sw', ':Rg <C-r><C-w><CR>', { noremap = true, silent = true })


-- LSP configs
pcall(require, "lsp")

-- Colorscheme setup
require("catppuccin").setup({
  flavour = "frappe",
  transparent_background = false,
  integrations = {
    treesitter = true,
    native_lsp = { enabled = true },
  },
})

vim.cmd.colorscheme("catppuccin-frappe")

-- Treesitter setup
require("nvim-treesitter.configs").setup {
  ensure_installed = { "lua", "python", "json", "bash", "yaml" },
  highlight = { enable = true },
}

-- Gitsigns setup
require('gitsigns').setup {
  signs = {
    add          = { text = '│', hl = 'GitSignsAdd' },
    change       = { text = '│', hl = 'GitSignsChange' },
    delete       = { text = '_', hl = 'GitSignsDelete' },
    topdelete    = { text = '‾', hl = 'GitSignsDelete' },
    changedelete = { text = '~', hl = 'GitSignsChange' },
    untracked    = { text = '┆', hl = 'GitSignsAdd' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}

-- Set git signs colors
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#7aa2f7' }) -- Blue for changes

-- Make line numbers more readable
vim.api.nvim_set_hl(0, 'LineNr', { fg = '#cad3f5' }) -- Line numbers - brighter and bold
vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#f4dbd6' }) -- Current line number - even brighter

-- Disable barbar's default keymaps to prevent conflicts
vim.g.barbar_auto_setup = false

-- Barbar setup
require'barbar'.setup {
  animation = true,
  auto_hide = false,
  tabpages = true,
  clickable = true,
  exclude_ft = {'javascript'},
  exclude_name = {'package.json'},
  icons = {
    buffer_index = false,
    buffer_number = false,
    button = '',
    diagnostics = {
      [vim.diagnostic.severity.ERROR] = {enabled = true, icon = 'ﬀ'},
      [vim.diagnostic.severity.WARN] = {enabled = false},
      [vim.diagnostic.severity.INFO] = {enabled = false},
      [vim.diagnostic.severity.HINT] = {enabled = true},
    },
    gitsigns = {
      added = {enabled = true, icon = '+'},
      changed = {enabled = true, icon = '~'},
      deleted = {enabled = true, icon = '-'},
    },
    filetype = {
      custom_colors = false,
      enabled = true,
    },
    separator = {left = '▎', right = ''},
    modified = {button = '●'},
    pinned = {button = '', filename = true},
    preset = 'default',
    alternate = {filetype = {enabled = false}},
    current = {buffer_index = true},
    inactive = {button = '×'},
    visible = {modified = {buffer_number = false}},
  },
  insert_at_end = false,
  insert_at_start = false,
  maximum_padding = 1,
  minimum_padding = 1,
  maximum_length = 30,
  minimum_length = 0,
  semantic_letters = true,
  letters = 'asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP',
  no_name_title = nil,
}



local function open_win_config_func()
    local scr_w = vim.opt.columns:get()
    local scr_h = vim.opt.lines:get()
    local tree_w = 120
    local tree_h = math.floor(tree_w * scr_h / scr_w)
    return {
	border = "double",
	relative = "editor",
	width = tree_w,
	height = tree_h,
	col = (scr_w - tree_w) / 2,
	row = (scr_h - tree_h) / 2
    }
end



local function nvim_tree_on_attach(bufnr)
    local api = require "nvim-tree.api"

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)
end



require("nvim-tree").setup {
    view = {
	signcolumn = "yes",
	float = {
	    enable = true,
	    open_win_config = open_win_config_func
	},
	cursorline = false
    },
    modified = {
	enable = true
    },
    renderer = {
	indent_width = 3,
	icons = {
	    show = {
		hidden = true
	    },
	    git_placement = "after",
	    bookmarks_placement = "after",
	    symlink_arrow = " -> ",
	    glyphs = {
		folder = {
		    arrow_closed = " ",
		    arrow_open = " ",
		    default = "",
		    open = "",
		    empty = "",
		    empty_open = "",
		    symlink = "",
		    symlink_open = ""
		},
		default = "󱓻",
		symlink = "󱓻",
		bookmark = "",
		modified = "",
		hidden = "󱙝",
		git = {
		    unstaged = "×",
		    staged = "",
		    unmerged = "󰧾",
		    untracked = "",
		    renamed = "",
		    deleted = "",
		    ignored = "∅"
		}
	    }
	}
    },
    filters = {
	git_ignored = false
    },
    hijack_cursor = true,
    sync_root_with_cwd = true,
    on_attach = nvim_tree_on_attach
}

-- Safe delete (handles lists of modes and buffer/global)
local function safe_del(mode, lhs, opts)
  opts = opts or {}
  if type(mode) == "table" then
    for _, m in ipairs(mode) do safe_del(m, lhs, opts) end
    return
  end
  -- try global
  pcall(vim.keymap.del, mode, lhs, { buffer = false })
  -- try buffer-local (current buffer)
  pcall(vim.keymap.del, mode, lhs, { buffer = 0 })
end

local function remap(mode, lhs, rhs, opts)
  opts = opts or {}
  -- delete first, both scopes
  safe_del(mode, lhs, { buffer = opts.buffer })
  -- then set
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- remap("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })


-- Force override window navigation after all plugins load
-- Clear any existing mappings first
remap('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
remap('n', '<C-j>', '<C-w>j', { desc = 'Move to left window' })
remap('n', '<C-k>', '<C-w>k', { desc = 'Move to left window' })
remap('n', '<C-l>', '<C-w>l', { desc = 'Move to left window' })
-- vim.keymap.del( 'n', '<C-j>')
-- vim.keymap.del( 'n', '<C-k>')
-- vim.keymap.del( 'n', '<C-l>')

-- -- Set window navigation
-- vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Move to left window' })
-- vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Move to bottom window' })
-- vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Move to top window' })
-- vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Move to right window' })
