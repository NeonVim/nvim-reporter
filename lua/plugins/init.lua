-- Any files inside the lua/plugins directory will also
-- automatically be sourced. These plugins are those that
-- do not require any configuration.

return {
  { "rcarriga/nvim-notify" },
  { "williamboman/mason.nvim" },
  { "neovim/nvim-lspconfig" },
  { "williamboman/mason-lspconfig.nvim" },
  { "onsails/lspkind-nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp-signature-help" },
  { "hrsh7th/cmp-nvim-lua",                       ft = { "lua" } },
  { "hrsh7th/cmp-nvim-lsp" },
  { "folke/neodev.nvim" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "nvim-lua/plenary.nvim" },
  { "rebelot/kanagawa.nvim" }, -- In colors.lua file
  { "lukas-reineke/lsp-format.nvim" },
  { "junegunn/fzf",                               build = function() vim.fn["fzf#install"]() end },
  { "tpope/vim-dispatch" },
  { "tpope/vim-repeat" },
  { "tpope/vim-surround" },
  { "tpope/vim-rhubarb" },
  { "tpope/vim-eunuch" },
  { "tpope/vim-sexp-mappings-for-regular-people", ft = { "clojure" } },
  { "guns/vim-sexp",                              ft = { "clojure" } },
  { "romainl/vim-cool" },
  { "kyazdani42/nvim-web-devicons" },
  { "lambdalisue/glyph-palette.vim" },
  { "posva/vim-vue",                              ft = { "vue" } },
  { "AndrewRadev/tagalong.vim" },
  { "tpope/vim-abolish" },
  { 'djoshea/vim-autoread' },
  { 'sago35/tinygo.vim' },
}
