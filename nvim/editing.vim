" Spaces not tabs!
set expandtab
set tabstop =2
set shiftwidth =2
set softtabstop =2

" Show linenumbers
set number
set cursorline
set hidden

" Enable Deoplete
let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('keyword_patterns', {'clojure': '[\w!$%&*+/:<=>?@\^_~\-\.#]*'})
set completeopt-=preview

" Floating window
"let g:float_preview#docked = 0
"let g:float_preview#max_width = 80
"let g:float_preview#max_height = 40
