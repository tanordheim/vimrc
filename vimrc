call pathogen#infect()

"-------------------------------------------------------------------------------
" GENERAL
"-------------------------------------------------------------------------------

" make sure we are in noncompatible mode
set nocompatible

" set how many lines of history vim has to remember
set history=10000

" enable filetype plugins
filetype plugin on
filetype indent on

" set map leader
let mapleader=","
let g:mapleader=","

"-------------------------------------------------------------------------------
" VIM USER INTERFACE
"-------------------------------------------------------------------------------

" add vertical lines on columns
set colorcolumn=120

" turn on wildmenu, makes tab completion for files/buffers act like bash
set wildmenu

" highlight current line
set cursorline

" completion options; select longest + show menu even if a single match is
" found
set completeopt=longest,menuone

" ignore compiled and temp files
set wildignore+=tmp/**,*.o,*~,.git\*,.DS_Store,node_modules,vendor

" show line, column number and relative position within a file in the status
" line
set ruler

" show line numbers
set number

" show partial commands (or size of selection in visual mode) in status line
set showcmd

" a buffer bcomes hidden when it's abandoned
set hidden

" configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" enable mouse if available
if has("mouse")
  set mouse=a
endif

" allow smarter completion by infering the case
set infercase

" ignore case when searching
set ignorecase

" when searching, try to be smart about cases
set smartcase

" highlight search results
set hlsearch

" makes search act like search in modern browsers
set incsearch

" don't redraw while executing macros (for performance)
set lazyredraw

" for regular expressions, turn magic on
set magic

" show matching brackets when text indicator is over them
set showmatch

" how many tenths of a second to blink when matching brackets
set mat=2

" no annoying sounds on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" make sure extra margin on left side is removed
set foldcolumn=0

"-------------------------------------------------------------------------------
" COLORS AND FONTS
"-------------------------------------------------------------------------------

" enable syntax highlighting
syntax enable

" use dark backgrounds
set background=dark

" set color scheme
colorscheme molokai

" use airline for a smoother status bar
let g:airline_powerline_fonts=1
let g:airline_theme="molokai"

" set extra options when running in gui mode
if has("gui_running")
  set guioptions-=T
  set guioptions-=e
  set t_Co=256
  set guitablabel=%M\ %t
endif

" set utf8 sas standard encoding
set encoding=utf8

" use unix as the standard file type
set ffs=unix,dos,mac

" highlight trailing spaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

"-------------------------------------------------------------------------------
" FILES, BACKUPS AND UNDO
"-------------------------------------------------------------------------------

" turn backup off, since most stuff is in source control anyway
set nobackup
set nowb
set noswapfile

" remember stuff between sessions
"
" '20  - remember marks for 20 previous files
" \"50 - save 50 lines for each register
" :20  - remember 20 items in command-line history
" /20  - remember 20 items in search history
" %    - remember the buffer list (if vim started without a file arg)
" n    - set name of viminfo file
set viminfo='20,\"50,:20,/20,%,n~/.viminfo

"-------------------------------------------------------------------------------
" TEXT, TAB AND INDENTATION
"-------------------------------------------------------------------------------

" use spaces instead of tabs
set expandtab

" be smart when using tabs
set smarttab

" 1 tab == 2 spaces
set shiftwidth=2
set tabstop=2

" round indent to multiple of shiftwidth for > and < commands
set shiftround

" linebreak on 120 characters
set tw=120

" enable auto intendation
set autoindent

" enable smart indentation
set smartindent

" don't wrap lines
set nowrap

"-------------------------------------------------------------------------------
" MOVING AROUND, TABS, WINDOWS AND BUFFERS
"-------------------------------------------------------------------------------

" treat long lines as break lines (usefil when moving around in them)
map j gj
map k gk

" disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" smart way to move between windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" switch cwd to the directory of the open buffer
nmap <silent> <leader>cd :lcd %:h<CR>

" create the full directory tree to the current buffer
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>

" return to last editing position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

" remember info about open buffers on close
set viminfo^=%

"-------------------------------------------------------------------------------
" STATUS LINE
"-------------------------------------------------------------------------------

" always show the status line
set laststatus=2

" format the status line
set statusline=%f\ %m\ %{fugitive#statusline()}\ %y%=%l,%c\ %P

"-------------------------------------------------------------------------------
" MISC
"-------------------------------------------------------------------------------

" toggle paste mode on/off
nmap <leader>o :set paste!<CR>


" Run the fugitive-vim Gstatus command
nmap <silent> <leader>s :Gstatus<CR>
" Toggle line numbers
nmap <leader>l :setlocal number!<CR>
" Toggle paste mode
nmap <leader>o :set paste!<CR>
" Change vertical movement to not jump around wrapped lines
nmap j gj
nmap k gk

"-------------------------------------------------------------------------------
" TAGBAR
"-------------------------------------------------------------------------------

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }
nmap <F3> :TagbarToggle<CR>

"-------------------------------------------------------------------------------
" TABULAR
"-------------------------------------------------------------------------------

nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a- :Tabularize /-<CR>
vmap <Leader>a- :Tabularize /-<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

"-------------------------------------------------------------------------------
" CTRL+P
"-------------------------------------------------------------------------------

nmap <Leader>o :CtrlP<CR>
let g:ctrlp_working_path_mode = ''

"-------------------------------------------------------------------------------
" NERDTREE
"-------------------------------------------------------------------------------

nmap <F2> :NERDTreeTabsToggle<CR>

"-------------------------------------------------------------------------------
" SYNTASTIC
"-------------------------------------------------------------------------------

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"-------------------------------------------------------------------------------
" GO LANGUAGE
"-------------------------------------------------------------------------------

autocmd BufNewFile,BufRead *.go setlocal noet ts=2 sw=2 sts=2
autocmd FileType go nmap <Leader>i <Plug>(go-info)
autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
autocmd FileType go nmap <Leader>r <Plug>(go-run)
autocmd FileType go nmap <Leader>t <Plug>(go-test)

"-------------------------------------------------------------------------------
" UNO LANGUAGE
"-------------------------------------------------------------------------------
autocmd BufNewFile,BufRead,BufReadPost *.uno set syntax=cs
autocmd FileType uno setlocal autoindent noexpandtab tabstop=4 shiftwidth=4
