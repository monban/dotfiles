local fn = vim.fn

local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({ 'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path })
end

require 'paq' {
  'savq/paq-nvim';
  'mattn/emmet-vim';
  'junegunn/fzf.vim';
  'akinsho/bufferline.nvim';
  'weilbith/nvim-code-action-menu';
  'neovim/nvim-lspconfig';
  'kyazdani42/nvim-web-devicons';
  'roxma/nvim-yarp';
  'kevinhwang91/rnvimr';
  'godlygeek/tabular';
  'sheerun/vim-polyglot';
  'tpope/vim-repeat';
  'tpope/vim-surround';
  'code-biscuits/nvim-biscuits';
  'fatih/vim-go';

  -- Treesitter
  'nvim-treesitter/nvim-treesitter';
  'nvim-treesitter/playground';

  -- Themes
  'tjdevries/colorbuddy.vim';
  'tjdevries/gruvbuddy.nvim';
  'Th3Whit3Wolf/onebuddy';

  -- Completion stuff
  'hrsh7th/nvim-cmp';
  'hrsh7th/cmp-nvim-lsp';
  'hrsh7th/cmp-buffer';
  'L3MON4D3/LuaSnip';
  'saadparwaiz1/cmp_luasnip';
}
