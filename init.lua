local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- Let packer manage itself
  -- LANGUAGE SERVER --
  use 'hrsh7th/cmp-nvim-lsp' -- Completion
  use 'neovim/nvim-lspconfig' -- Configuring LSPs
  use 'williamboman/nvim-lsp-installer' -- For installing language servers
  use 'quangnguyen30192/cmp-nvim-ultisnips'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- CORE --
  use { 'Pocco81/AutoSave.nvim' } -- Auto saves files
  use { 'nvim-telescope/telescope.nvim', requires = { {'nvim-lua/plenary.nvim'} } }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
  use 'tpope/vim-dispatch' -- Allows functions to run asyncrhonously from within VIM (:Dispatch)
  use 'tpope/vim-repeat' -- Allows plugins to repeat 
  use 'tpope/vim-surround' -- Use cs''[encloser] (that's a double-qutation mark) to modify encloser, ysiw[encloser] to add encloser
  use 'tpope/vim-unimpaired' -- Key mappings
  use 'tpope/vim-eunuch' -- Rename files
  use 'tpope/vim-commentary' -- gcc to comment (or 3gcc)
  use 'akinsho/toggleterm.nvim' -- Toggling the terminal 
  use 'romainl/vim-cool' -- Turns off hlsearch after search is done
  use 'tpope/vim-rhubarb' -- Allows :Gbrowse which opens up file in Github
  use 'vim-scripts/BufOnly.vim' -- Close all buffers but the current one
  use 'markonm/traces.vim' -- highlights patterns and ranges for Ex commands in Command-line mode.
  use 'djoshea/vim-autoread' -- Reloads files on change
  use 'SirVer/ultisnips' -- Vim snippets
  use 'jtmkrueger/vim-c-cr' -- Auto indent brackets after enter
  use 'tpope/vim-fugitive' -- Git wrapper (:G followed by git commands)
  use 'jiangmiao/auto-pairs' -- Auto pairing of brackets/parentheses
  use 'ThePrimeagen/harpoon' -- Harpooning specific files for quick reference
  use {
    'prettier/vim-prettier',
    run = 'npm install',
  }
  -- VIEW -- 
  use 'kyazdani42/nvim-web-devicons' -- Icons
  use 'kyazdani42/nvim-tree.lua' -- Tree
  use { 'goolord/alpha-nvim', branch = 'main', requires = { 'kyazdani42/nvim-web-devicons' } }
  use 'airblade/vim-gitgutter' -- Shows Git status in lefthand side
  use 'itchyny/lightline.vim' -- Adds status line at bottom of the file
  use 'itchyny/vim-gitbranch' -- Shows branch name in lightline
  use 'sainnhe/gruvbox-material' -- Gruvbox w/ treesitter support
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'sainnhe/sonokai' -- Color theme for vimwiki
  use 'lambdalisue/glyph-palette.vim' -- Colors for icons
  -- LANGUAGES --
  use 'adelarsq/vim-matchit' -- Allows HTML tag jumping with %
  use 'mattn/emmet-vim' -- Enables emmet (coc-emmet provides autocomplete)
  use 'AndrewRadev/tagalong.vim' -- Automatically changes closing tags
  use 'alvan/vim-closetag' -- Auto-closing of HTML tags
  use 'posva/vim-vue'
  use 'hashivim/vim-terraform' -- Adds auto-formatting + highlighting for terraform
  use 'ap/vim-css-color' --Colors for CSS
  use 'jparise/vim-graphql' -- Install linting for graphQl
  use 'vimwiki/vimwiki' -- Notetaking app
  use { 'b0o/mapx.nvim', branch = 'main' }
end)

-- Main Imports
require("settings")
require("colors")
require("mappings")
require("functions")
require("autocommands")

-- Plugin-specific settings
require("_fugitive")
require("_ultisnips")
require("_miscellaneous")
require("_toggle-terminal")
require("_auto-save")
require("_telescope")
require("_treesitter")
require("_alpha")
require("_harpoon")
require("_nvim_tree")
require("_nvim_lspconfig")
