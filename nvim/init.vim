"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath=&runtimepath

" Plug setup
" sh -c 'curl -fLo ${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
" iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |` ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force"


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
	Plug 'tpope/vim-commentary'
	Plug 'gosukiwi/vim-atom-dark'
	Plug 'joshdick/onedark.vim'
	"Plug 'tomasiser/vim-code-dark'
	Plug 'Mofiqul/vscode.nvim'
	
	Plug 'neovim/nvim-lspconfig'
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
	Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
	Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
	Plug 'sbdchd/neoformat'

	call plug#end()

	" Neoformat to use a project-local version of Prettier
	let g:neoformat_try_node_exe = 1
	let g:neoformat_try_formatprg = 1

	" autocmd BufWritePre,TextChanged *.js,*.jsx,*.ts,*.tsx Neoformat
	" autocmd BufWritePre,TextChanged *.md Neoformat
	" autocmd BufWritePre,TextChanged *.py Neoformat

	au FileType python setlocal formatprg=autopep8\ -

	"colorscheme onedark 
	lua <<EOF
require('vscode').load('dark')
EOF

endif

" remap Esc to exit insert mode in :term
tnoremap <Esc> <C-\><C-n>>

" Clear search hl
map <leader>n :nohlsearch<cr>

" Quick buffer switch
nmap <leader><tab> :b#<CR>

" Allow to switch buffer without saving
"set hidden

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

