if has('win32')
	source $VIMRUNTIME/mswin.vim
	echo serverstart('\\.\pipe\nvim')
endif


