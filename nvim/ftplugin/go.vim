augroup golang
  autocmd!
  au BufWritePre *.go :1,$ !gofmt
  au BufWritePre *.go :lua goimports()
augroup end

