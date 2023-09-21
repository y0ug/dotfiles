" set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath=&runtimepath

" Plug setup
" sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |` ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force"


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

" surround
" replace single quote to double cs'"
" comment gcc
"
let mapleader = ","
let g:mapleader = ","

" Need to be set first due to theme
syntax on


if exists('g:vscode')
	" VSCode extension
	xmap gc  <Plug>VSCodeCommentary
	nmap gc  <Plug>VSCodeCommentary
	omap gc  <Plug>VSCodeCommentary
	nmap gcc <Plug>VSCodeCommentaryLine
else
	" ordinary Neovim
	call plug#begin()
	Plug 'gosukiwi/vim-atom-dark'
	Plug 'joshdick/onedark.vim'
	"Plug 'tomasiser/vim-code-dark'
	Plug 'Mofiqul/vscode.nvim'


	Plug 'tpope/vim-surround'
	Plug 'tpope/vim-commentary'

	Plug 'williamboman/mason.nvim'
	" Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'neovim/nvim-lspconfig'

	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
	Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
	Plug 'sbdchd/neoformat'

	" Plug 'github/copilot.vim'
	call plug#end()

	" Neoformat to use a project-local version of Prettier
	let g:neoformat_try_node_exe = 1
	let g:neoformat_try_formatprg = 1

	" autocmd BufWritePre,TextChanged *.js,*.jsx,*.ts,*.tsx Neoformat
	" autocmd BufWritePre,TextChanged *.md Neoformat
	" autocmd BufWritePre,TextChanged *.py Neoformat
	
	" Fix default comment
	autocmd FileType c,cpp,java setlocal commentstring=//\ %s

	"colorscheme onedark
	

	lua <<EOF
require('vscode').load('dark')
require("mason").setup()
-- require("mason-lspconfig").setup()

if vim.fn.has("gui_running") then
    vim.opt.guifont = "Source Code Pro:h16"
end
EOF


endif

" Enable copy-past with Ctrl-Shift x/c/v
vnoremap <C-S-x> "+x
vnoremap <C-S-c> "+y
map <C-S-v> "+p
cmap <C-S-v> <C-R>+ 
map <C-S-v> "+p
" insert mode
inoremap <C-S-v> <C-R>+

" remap Esc to exit insert mode in :term
tnoremap <Esc> <C-\><C-n>>

" Clear search hl
map <leader>n :nohlsearch<cr>

" Quick buffer switch
nmap <leader><tab> :b#<CR>

" Relative number
set number relativenumber

" Allow to switch buffer without saving
"set hidden

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" Paste
map <leader>pp :setlocal paste!<cr>

" Fast saving
map <Leader>w :w<CR>
imap <Leader>w <ESC>:w<CR>
vmap <Leader>w <ESC><ESC>:w<CR>

map <Leader>q :q<CR>
map <Leader>W :wq<CR>

" :W sudo saves the file
command! W w !sudo tee % > /dev/null

" edit/reload .vimrc
nmap <leader>V :source $MYVIMRC<cr>
nmap <leader>v :edit $MYVIMRC<cr>

