" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" general plugins
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-sensible'
Plug 'github/copilot.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tyru/open-browser.vim'
Plug 'justinmk/vim-sneak'
Plug 'mbbill/undotree'
Plug 'tpope/vim-sleuth'
" visual stuff
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" git
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-fugitive'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tyru/open-browser-github.vim'
" lang specific
Plug 'fatih/vim-go'
Plug 'jelera/vim-javascript-syntax'
Plug 'buoto/gotests-vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" general settings
syntax enable
set encoding=utf-8
set fileencoding=utf-8
set number
set splitright
set ignorecase
set smartcase
set foldmethod=indent
set nofoldenable

" whitespace
filetype plugin indent on
" set tabstop=4
" set softtabstop=4
" set shiftwidth=4
" set expandtab
set smartindent
" autocmd Filetype javascript setlocal ts=2 sts=2 sw=2
autocmd BufNewFile,BufRead *.go,*.mod setlocal noexpandtab tabstop=4 shiftwidth=4
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
noremap <silent> <C-S-Left> :vertical resize +1<CR>
noremap <silent> <C-S-Right> :vertical resize -1<CR>
noremap <silent> <C-S-Up> :horizontal resize +1<CR>
noremap <silent> <C-S-Down> :horizontal resize -1<CR>
" toggle nerdtree
map <F2> :NERDTreeToggle<CR>
" toggle copy/paste mode
map <F3> :call ToggleCopyPasteMode()<CR>
" find current file in tree
map <F4> :NERDTreeFind<cr>
map <F5> :UndotreeToggle<cr>
" fzf -> ctrlp
nnoremap <c-p> :FZF<cr>
" vim-go
au FileType go nmap <leader>r <Plug>(go-referrers)
au FileType go nmap <leader>gd <Plug>(go-def-vertical)
" ripgrep in cwd
nmap <leader>f :Rg<CR>
" open quickfix window in a vertical split
autocmd! FileType qf nnoremap <buffer> <leader><Enter> <C-w><Enter><C-w>L

" coc
let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-go', 'coc-html']
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" copilot
let g:copilot_filetypes={
    \ '*': v:false,
    \ 'go': v:true,
    \ 'python': v:true,
    \ 'javascript': v:true,
\ }


" NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" start nerdtree on launch and switch to prev window
" autocmd VimEnter * NERDTree
" autocmd VimEnter * wincmd p
" close nerdtree if only pane left
autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" airline
let g:airline_theme='deus'
let g:airline_powerline_fonts=1

" vim-go
let g:go_fmt_command="goimports"
let g:go_imports_mode="goimports"
let g:go_highlight_types=1
let g:go_highlight_fields=1
let g:go_highlight_functions=1
let g:go_highlight_methods=1
let g:go_highlight_operators=1
let g:go_highlight_extra_types=1
let g:go_highlight_build_constraints=1
let g:go_doc_popup_window=1
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_referrers_mode='gopls'
let g:go_debug_address='localhost:2345'
let g:go_debug_windows = {
    \ 'vars': 'rightbelow 50vnew',
    \ 'stack': 'rightbelow 10new',
\ }
let g:go_debug_mappings = {
    \ '(go-debug-continue)': {'key': 'c', 'arguments': '<nowait>'},
    \ '(go-debug-next)': {'key': 'n', 'arguments': '<nowait>'},
    \ '(go-debug-step)': {'key': 's'},
    \ '(go-debug-print)': {'key': 'p'},
    \ '(go-debug-breakpoint)': {'key': 'b'},
\}


" gotests-vim
let g:gotests_template = ''

" vim-sneak
map f <Plug>Sneak_s
map F <Plug>Sneak_S

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
    set clipboard^=unnamed,unnamedplus
endfun

