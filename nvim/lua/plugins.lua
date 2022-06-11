local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path })
end

require 'paq' {
  'savq/paq-nvim';
  'mattn/emmet-vim';
  'junegunn/fzf.vim';
  'ellisonleao/gruvbox.nvim';
  'rktjmp/lush.nvim';
  'preservim/nerdcommenter';
  'akinsho/bufferline.nvim';
  'weilbith/nvim-code-action-menu';
  'neovim/nvim-lspconfig';
  'nvim-treesitter/nvim-treesitter';
  'kyazdani42/nvim-web-devicons';
  'roxma/nvim-yarp';
  'kevinhwang91/rnvimr';
  'godlygeek/tabular';
  'sheerun/vim-polyglot';
  'tpope/vim-repeat';
  'tpope/vim-surround';
  'code-biscuits/nvim-biscuits';
  'fatih/vim-go';

  -- Completion stuff
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/nvim-cmp';
  'hrsh7th/cmp-buffer';
  'L3MON4D3/LuaSnip';
  'saadparwaiz1/cmp_luasnip';
}
