augroup golang
  autocmd!
  au BufWritePre *.go :lua Goimports()
augroup end

