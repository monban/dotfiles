let g:configpath = stdpath('config')
execute 'source ' . g:configpath . '/plugins.vim'
execute 'source ' . g:configpath . '/editing.vim'
execute 'source ' . g:configpath . '/bindings.vim'
execute 'source ' . g:configpath . '/appearence.vim'
execute 'source ' . g:configpath . '/goyo.vim'
execute 'source ' . g:configpath . '/lsp.vim'
execute 'source ' . g:configpath . '/snippets.vim'

" Reload init.vim after save
autocmd! BufWritePost init.vim source $MYVIMRC

