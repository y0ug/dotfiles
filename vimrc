" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" <ctrl>-i <ctrl>-o prev/next jmps position
" u undo last change
" <ctrl>-r redo changes which were undone
" :reg list register ( delete/yank/etc...)
" :ls or :buffers or files list buffers
" bN go to buffer n
" N<ctrl>-^ go to n buffer
" gf follow filename
" gF follow filename and line number
" n and N next/prev search
" <leader>-n clear search
" <ctrl>-d or <ctrl>-u scroll down/up mid-screen
" <ctrl>-e or <ctrl>-y scroll down/up bottom/up screen
" marks list marks
" ma m follow by letter set mark (upper case is global mark)
" `a go to mark a
" `. go to last change pos
" '. go to last change line
" di" delte inside quote
" da" delete inside quote and quote
" ctrl-a/x increment decrease
" u/U lower/uppercase
" mode normal ctrl-r " to past inside command
" MakeTags rebuild tags list
" ctrl-] go to function definition
" g ctrl-] show list of tags
" ctrl-t go back (pop tag stack)
" :grep! -R "pattern" out/  " search pattern inside folder out
" cope open quickfix list aka the grep result
" cnew cold next/prev in quickfix list
" lope open location aka the lgrep result
" shift-{/} move next braces
" shift-(/) move paragraph
" * search word under cursor
" shift-K search in man/doc
" autocmd BufWritePost * execute "!cp % ~/infected"
" Autocomplete in insert mode ctrl-x ctr-, f for file, t for synonyme, ] for
" ctags
" ctrl-g show file info cols/lines
" g; go to last edit
" bo 15sp +te " open a term in bellow split in nvim
" [[ or ]] go next function/class ]m [m move next function
" nvim term switch to normal mode Ctrl+\ Ctrl+n

set nocompatible

let mapleader = " "
let g:mapleader = " "

syntax enable
filetype plugin on
filetype indent on

set autoindent
set nobackup noswapfile noundofile
set hlsearch incsearch ignorecase smartcase
set ts=4 sw=4
set mouse=a
set noeb vb t_vb= " disable esc belt

set number relativenumber

runtime ftplugin/man.vim

call plug#begin('~/.vim/plugged')
Plug 'editorconfig/editorconfig-vim'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-commentary'
Plug 'tomasiser/vim-code-dark'
call plug#end()

try
	set background=dark
	colorscheme codedark 
	set termguicolors
	let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
catch
endtry

" Explore options j
" :Ex open it, gh show hidden files
" - go up, D delete, R rename, s sort, f1 help
let g:netrw_banner=0
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu
" Global undo folder
if has('persistent_undo')
	silent !mkdir -p $HOME/.vim/undo
	set undofile
	set undodir=$HOME/.vim/undo
endif

if has('nvim')
	" remap Esc to exit insert mode in :term
	tnoremap <Esc> <C-\><C-n>>
endif

" Clear search hl
map <leader>n :nohlsearch<cr>

" Quick buffer switch
nmap <leader>bb :b#<CR>
nmap <leader>` :b#<CR>

nmap <S-H>bp :bp<CR>
nmap <S-L>bn :bn<CR>
nmap <leader>bp :bp<CR>
nmap <leader>bn :bn<CR>
nmap <leader>bd :bd<CR>
nmap <leader>bl :buffers<CR>

" Allow to switch buffer without saving
set hidden

" Fast saving
map <C-S> :w<CR>
imap <C-S> <ESC>:w<CR>
vmap <C-S> <ESC><ESC>:w<CR>


" :W sudo saves the file
command! W w !sudo tee % > /dev/null

" edit/reload .vimrc
nmap <leader>V :source $MYVIMRC<cr>
nmap <leader>v :edit $MYVIMRC<cr>

" no stderr on command output
" set shellredir=>

" *restore-cursor* *last-position-jump*
autocmd BufReadPost *
	\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
	\ |   exe "normal! g`\""
	\ | endif

"autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc

"autocmd FileType yaml setlocal ts=2 sw=2 sts=0 expandtab
"autocmd FileType yaml.ansible setlocal ts=2 sw=2 sts=0 expandtab
"autocmd Filetype python setlocal ts=4 sw=4 sts=0 expandtab smarttab
"autocmd Filetype javascript setlocal ts=4 sw=4 sts=0 expandtab smarttab
"autocmd FileType markdown setlocal ts=4 sw=4 sts=0 smarttab " spell

" Trim trailing whitespace for python
autocmd BufWritePre *.py :%s/\s\+$//e 
" gq to apply to selection
"au FileType python setlocal formatprg=autopep8\ -

" insert mode ctrl-x ctrl-t
set thesaurus+=~/.vim/thesaurus/mthesaur.txt

