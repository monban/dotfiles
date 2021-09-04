	if exists("did_load_filetypes")
	  finish
	endif
	augroup filetypedetect
	  au! BufRead,BufNewFile *.fish		setfiletype fish
	augroup END
