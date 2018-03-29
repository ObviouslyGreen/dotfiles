" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" general plugins
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-sensible'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }
Plug 'natebosch/vim-lsc'
" visual stuff
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
" lang specific
Plug 'fatih/vim-go'
Plug 'jelera/vim-javascript-syntax'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" general settings
syntax enable
set encoding=utf-8
set number
set splitright
set ignorecase
set smartcase

" whitespace
filetype plugin indent on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·,space:·
set list
" strip trailing whitespace automatically
autocmd BufWritePre *.txt,*.js,*.py,*.sh,*.go :call CleanExtraSpaces()

" colors
set t_Co=256
set termguicolors
set background=dark
colorscheme gruvbox

" keybinds
" easier split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" find current file in tree
map <leader>f :NERDTreeFind<cr>
" toggle nerdtree
map <F2> :NERDTreeToggle<CR>
" toggle copy/paste mode
map <F3> :call ToggleCopyPasteMode()<CR>
" fzf -> ctrlp
nnoremap <c-p> :FZF<cr>
" vim-go get referrers
nmap <leader>r <Plug>(go-referrers)
nmap <leader>f :Ag<CR>

" YouCompleteMe
" don't show preview pane
set completeopt-=preview
" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" start nerdtree on launch and switch to prev window
" autocmd VimEnter * NERDTree
" autocmd VimEnter * wincmd p
" close nerdtree if only pane left
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" open nerdtree on new tab as well
autocmd BufWinEnter * silent NERDTreeMirror

" airline
let g:airline_theme='deus'
let g:airline_powerline_fonts=1

" vim-go
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

" setup vim-lsc
let g:lsc_server_commands = {'go': 'go-langserver'}
let g:lsc_enable_autocomplete = v:false
" gd overrides vim-go go to def
let g:lsc_auto_map = {
    \ 'GoToDefinition': 'gd',
    \ 'FindReferences': 'gr',
    \}

" functions
fun CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

fun ToggleCopyPasteMode()
    " toggle line numbers and whitespace chars for better system / terminal copy paste
    set number!
    set list!
endfun

