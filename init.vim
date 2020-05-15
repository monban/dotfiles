"  Plug 'clktmr/vim-gdscript3'
call plug#begin('~/.local/share/nvim/plugs')
  Plug 'scrooloose/nerdtree'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'scrooloose/nerdcommenter'
  Plug 'godlygeek/tabular'
  Plug 'morhetz/gruvbox'
  Plug 'vim-airline/vim-airline'
  Plug 'junegunn/goyo.vim'
  Plug 'sheerun/vim-polyglot'
  Plug 'neovim/nvim-lsp'
call plug#end()

" Colors and theme
set termguicolors
autocmd vimenter * colorscheme gruvbox
set guifont=FiraCode:h26
let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_cursor_vfx_particle_density=70.0
let g:neovide_cursor_vfx_opacity=600.0
let g:neovide_cursor_animation_length=0.25
let g:neovide_transparency=0.9
let g:airline_powerline_fonts = 1
hi Normal ctermbg=none guibg=none

" Bindings
map <C-e> :NERDTreeToggle<CR>
map <C-s> :w<CR>
map <C-g> :Goyo<CR>

" Spaces not tabs!
set expandtab
set tabstop =2
set shiftwidth =2
set softtabstop =2

" Show linenumbers
set number
set cursorline

" Sane defaults
set hidden

" Goyo settings
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX) && !exists('g:neovide')
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  set nocursorline
  let g:neovide_transparency=1.0
  let g:neovide_fullscreen=v:true
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX) && exists('g:neovide')
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  set cursorline
  let g:neovide_transparency=0.9
  let g:neovide_fullscreen=v:false
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" Reload init.vim after save
autocmd! BufWritePost init.vim source $MYVIMRC

