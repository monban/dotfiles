function! Snippet(template)
  " Check if global variable g:snippet path is defined and use it if so
  if exists('g:snippet_path')
    let l:snippet_path = g:snippet_path
  else
    " Default to a snippets subdirectory under where vim.init is
    let l:snippet_path = stdpath('config') . '/snippets'
  endif

  let l:templatefile =  l:snippet_path . '/' . a:template
  " Check if snippet file exists
  try
    execute 'read ' . l:templatefile
    :/<SNIPPET_CURSOR_LOCATION><CR>c//e<CR>
  catch /E486:/
    echom "Warning: unable to find default cursor location in snippet"
  endtry
endfunction
