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
  colorscheme molokai
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
  highlight Normal ctermbg=none guibg=none
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

