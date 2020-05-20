execute 'source ' . stdpath('config') . '/plugins.vim'
execute 'source ' . stdpath('config') . '/editing.vim'
execute 'source ' . stdpath('config') . '/bindings.vim'
execute 'source ' . stdpath('config') . '/appearence.vim'
execute 'source ' . stdpath('config') . '/goyo.vim'
execute 'source ' . stdpath('config') . '/lsp.vim'

" Reload init.vim after save
autocmd! BufWritePost init.vim source $MYVIMRC

