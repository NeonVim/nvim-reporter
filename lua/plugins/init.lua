local u = require("functions.utils")

local setup = function(mod, remote)
  if remote == nil then
    require(mod)
  else
    local status = pcall(require, remote)
    if not status then
      print(remote .. " is not downloaded.")
      return
    else
      local local_config = require(mod)
      if type(local_config) == "table" then
        local_config.setup()
      end
    end
  end
end

local no_setup = function(mod)
  local status = pcall(require, mod)
  if not status then
    print(mod .. " is not downloaded.")
    return
  else
    require(mod).setup({})
  end
end

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  print("Packer installed, please exit NVIM and re-open, then run :PackerInstall")
  return
end

local packer = require("packer")

local os = u.get_os() == "Darwin" and "mac" or "linux"
local packer_options = {
  snapshot_path = vim.fn.stdpath("config") .. "/lockfiles/" .. os .. "/packer_snapshots",
}

if u.get_os() == "Darwin" then
  packer_options.max_jobs = 4
end

packer.init(packer_options)

packer.startup(function(use)
  use("wbthomason/packer.nvim")
  use("neovim/nvim-lspconfig")
  use({ "williamboman/mason-lspconfig.nvim" })
  use({ "jayp0521/mason-nvim-dap.nvim" })
  use({ "williamboman/mason.nvim", no_setup("mason") })
  use("onsails/lspkind-nvim")
  use("hrsh7th/nvim-cmp")
  use("hrsh7th/cmp-nvim-lsp-signature-help")
  use({ "hrsh7th/cmp-nvim-lua", ft = { "lua" } })
  use("hrsh7th/cmp-nvim-lsp")
  use("hrsh7th/cmp-buffer")
  use("hrsh7th/cmp-path")
  -- Visual Studio Code Debugger Requires Special Installation
  use { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } }
  use {
    "microsoft/vscode-js-debug",
    opt = true,
    run = "npm install --legacy-peer-deps && npm run compile"
  }
  use("nvim-lua/plenary.nvim")
  use("rebelot/kanagawa.nvim") -- In colors.lua file
  use({
    "quangnguyen30192/cmp-nvim-ultisnips",
    config = setup("plugins.ultisnips"),
  })
  use({ "Olical/conjure", config = setup("plugins.conjure") })
  use({ "lukas-reineke/lsp-format.nvim" })
  use({
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim", "junegunn/fzf" },
    config = setup("plugins.telescope", "telescope"),
  })
  use({
    "nvim-telescope/telescope-file-browser.nvim",
    requires = "nvim-telescope/telescope.nvim",
  })
  use({ 'nvim-telescope/telescope-fzf-native.nvim',
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    requires = "nvim-telescope/telescope.nvim" })
  use({
    "junegunn/fzf",
    run = function()
      vim.fn["fzf#install"]()
    end,
  })
  use({ "kevinhwang91/nvim-bqf", requires = "junegunn/fzf.vim", config = setup("plugins.bqf", "bqf") })
  use("tpope/vim-dispatch")
  use("tpope/vim-repeat")
  use("tpope/vim-surround")
  use("tpope/vim-unimpaired")
  use("tpope/vim-rhubarb")
  use("tpope/vim-eunuch")
  use("tpope/vim-obsession")
  use({ "tpope/vim-sexp-mappings-for-regular-people", ft = { "clojure" } })
  use({ "guns/vim-sexp", ft = { "clojure" } })
  use({ "numToStr/Comment.nvim", config = no_setup("Comment") })
  use({ "numToStr/FTerm.nvim", config = setup("plugins.fterm", "FTerm") })
  use("romainl/vim-cool")
  use("SirVer/ultisnips")
  use({ "tpope/vim-fugitive", config = setup("plugins.fugitive") })
  use({ "windwp/nvim-autopairs", config = setup("plugins.autopairs", "nvim-autopairs") })
  use({
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
    config = setup("plugins.lualine", "lualine"),
  })
  use({
    "alvarosevilla95/luatab.nvim",
    config = setup("plugins/luatab", "luatab"),
    requires = "kyazdani42/nvim-web-devicons",
  })
  use({
    "lewis6991/gitsigns.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = setup("plugins.gitsigns", "gitsigns"),
  })
  use({ "gelguy/wilder.nvim", config = setup("plugins.wilder", "wilder") })
  use({
    "nvim-treesitter/nvim-treesitter",
    config = setup("plugins.treesitter", "nvim-treesitter"),
  })
  use({ "nvim-treesitter/playground", requires = "nvim-treesitter/nvim-treesitter" })
  use({ "p00f/nvim-ts-rainbow", requires = "nvim-treesitter/nvim-treesitter" })
  use("andymass/vim-matchup")
  use({
    "nvim-treesitter/nvim-treesitter-context",
    requires = "nvim-treesitter/nvim-treesitter",
    confg = setup("plugins.treesitter-context", "treesitter-context"),
  })
  use({ "kyazdani42/nvim-web-devicons", no_setup("nvim-web-devicons") })
  use({
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = setup("plugins.diffview", "diffview"),
  })
  use({ "petertriho/nvim-scrollbar", config = setup("plugins.scrollbar", "scrollbar") })
  use({ "karb94/neoscroll.nvim", config = setup("plugins.neoscroll", "neoscroll") })
  use({ "harrisoncramer/jump-tag", config = setup("plugins.jump-tag", "jump-tag") })
  use("lambdalisue/glyph-palette.vim")
  use({ "posva/vim-vue", ft = { "vue" } })
  use({ "mattn/emmet-vim", ft = { "html", "vue", "javascript", "javascriptreact", "typescriptreact" } })
  use("AndrewRadev/tagalong.vim")
  use("alvan/vim-closetag")
  use({ "harrisoncramer/psql", config = no_setup("psql") })
  use({ "kazhala/close-buffers.nvim", config = no_setup("close_buffers") })
  use({ "rcarriga/nvim-notify", config = setup("notify", "plugins.notify") })
  use("ton/vim-bufsurf")
  use({ "AckslD/messages.nvim", config = setup("plugins.messages", "messages") })
  use({ 'djoshea/vim-autoread' })
  use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" }, config = setup("plugins.dap", "dap") })
  use {
    "nvim-neotest/neotest",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-go",
    },
    setup("plugins.neotest", "neotest")
  }
  use { 'ggandor/leap.nvim', setup("plugins.leap", "leap") }
end)
