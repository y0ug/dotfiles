"set runtimepath^=~/.vim runtimepath+=~/.vim/after
"let &packpath=&runtimepath

let mapleader = ","
let g:mapleader = ","


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
	"Plug 'tomasiser/vim-code-dark'
	Plug 'Mofiqul/vscode.nvim'
	
	Plug 'neovim/nvim-lspconfig'
	Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
	Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
	Plug 'sbdchd/neoformat'

	call plug#end()
	"colorscheme codedark 

	" Neoformat to use a project-local version of Prettier
	let g:neoformat_try_node_exe = 1
	autocmd BufWritePre,TextChanged *.js,*.jsx,*.ts,*.tsx Neoformat
	autocmd BufWritePre,TextChanged *.md Neoformat
	autocmd BufWritePre,TextChanged *.py Neoformat

	lua <<EOF
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

