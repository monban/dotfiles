augroup golang
  autocmd!
  au BufWritePre *.go :lua vim.lsp.buf.formatting_sync()
  au BufWritePre *.go :lua goimports()
  au CursorHold *.go :lua vim.lsp.buf.hover()
augroup end

