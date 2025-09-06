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

vim.call('plug#end')

-- Basic settings
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.undofile = true

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

-- Theme (only if plugin is loaded)
vim.defer_fn(function()
    if pcall(vim.cmd, 'colorscheme catppuccin-mocha') then
        -- Theme loaded successfully
    end
end, 100)

-- nvim-tree setup
require("nvim-tree").setup({
    sort_by = "case_sensitive",
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = false,
    },
    on_attach = function(bufnr)
        local api = require('nvim-tree.api')
        
        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)
        
        -- Custom mappings for h/l
        vim.keymap.set('n', 'l', api.node.open.edit, { buffer = bufnr, noremap = true, silent = true, desc = 'Open' })
        vim.keymap.set('n', 'h', api.node.navigate.parent_close, { buffer = bufnr, noremap = true, silent = true, desc = 'Close Directory' })
        
        -- Mark files with Tab
        vim.keymap.set('n', '<Tab>', api.marks.toggle, { buffer = bufnr, noremap = true, silent = true, desc = 'Toggle Mark' })
        
        -- Delete marked files with d
        vim.keymap.set('n', 'd', api.marks.bulk.delete, { buffer = bufnr, noremap = true, silent = true, desc = 'Delete Marked' })
        
        -- Ensure Ctrl+h works to go back to previous window
        vim.keymap.set('n', '<C-h>', '<C-w>h', { buffer = bufnr, noremap = true, silent = true })
    end,
})

-- Keymaps
vim.keymap.set('n', '<leader>f', ':Files<CR>')
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<C-S-f>', ':Rg<CR>')
vim.keymap.set('n', '<leader>bd', ':confirm bdelete<CR>')
vim.keymap.set('n', '<S-h>', ':bprev<CR>')
vim.keymap.set('n', '<S-l>', ':bnext<CR>')

-- Move between splits with CTRL + h/j/k/l
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Close window with leader wq
vim.keymap.set('n', '<leader>wq', ':q<CR>', { noremap = true, silent = true })


-- LSP configs
pcall(require, "lsp")

-- Colorscheme setup
require("catppuccin").setup({
  flavour = "macchiato",
  transparent_background = true,
  integrations = {
    treesitter = true,
    native_lsp = { enabled = true },
  },
})

-- vim.cmd.colorscheme("catppuccin-macchiato")

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
