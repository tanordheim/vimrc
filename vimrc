" This file is copied/inspired by Gary Bernhardt's .vimrc file
" https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
"
" vim:set ts=2 sts=2 sw=2 expandtab:

call pathogen#infect()

"-------------------------------------------------------------------------------
" BASIC EDITING CONFIGURATION
"-------------------------------------------------------------------------------
set nocompatible
" allow unsaved background buffers and remember marks/undo for them
set hidden
" remember more commands and search history
set history=10000
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
set cmdheight=2
set switchbuf=useopen
set numberwidth=5
set showtabline=2
set winwidth=79
" This makes RVM work inside Vim. I have no idea why.
set shell=bash
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Store temporary files in a central spot
set backup
set backupdir=~/.tmp
set directory=~/.tmp
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" ignore some files when completing file names
set wildignore+=tmp/**,doc/yardoc/**
" make tab completion for files/buffers act like bash
set wildmenu
set previewheight=30
let mapleader=","

"-------------------------------------------------------------------------------
" CUSTOM AUTOCMDS
"-------------------------------------------------------------------------------
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END

"-------------------------------------------------------------------------------
" COLOR
"-------------------------------------------------------------------------------
set t_Co=256 " 256 colors
set background=dark
let g:solarized_termcolors=256
colorscheme solarized

"-------------------------------------------------------------------------------
" STATUS LINE
"-------------------------------------------------------------------------------
set statusline=%f\ %m\ %{fugitive#statusline()}\ %y%=%l,%c\ %P

"-------------------------------------------------------------------------------
" MISC KEY MAPS
"-------------------------------------------------------------------------------
map <leader>y "*y
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
nnoremap <leader><leader> <c-^>
" Change the current directory to the directory containing the current file
nmap <silent> <leader>cd :lcd %:h<CR>
" Create the full directory tree containing the current file
nmap <silent> <leader>md :!mkdir -p %:p:h<CR>
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
" COMMAND-T
"-------------------------------------------------------------------------------
" Easy access to the Command-T buffer window
nnoremap <silent> ; :CommandTBuffer<CR>
" Ignore some files when completing
set wildignore+=.git
set wildignore+=bower_components
set wildignore+=node_modules
set wildignore+=.DS_Store

"-------------------------------------------------------------------------------
" NEOCOMPLETE
"-------------------------------------------------------------------------------
let g:neocomplete#enable_at_startup = 1

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
nmap <F8> :TagbarToggle<CR>

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
nmap <Leader>t :CtrlP<CR>

"-------------------------------------------------------------------------------
" NERDTREE
"-------------------------------------------------------------------------------
map <C-n> :NERDTreeToggle<CR>

"-------------------------------------------------------------------------------
" ARROW KEYS ARE UNACCEPTABLE
"-------------------------------------------------------------------------------
map <Left> <Nop>
map <Right> <Nop>
map <Up> <Nop>
map <Down> <Nop>

"-------------------------------------------------------------------------------
" RENAME CURRENT FILE
"-------------------------------------------------------------------------------
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

"-------------------------------------------------------------------------------
" Md5 COMMAND
" Show the MD5 of the current buffer
"-------------------------------------------------------------------------------
command! -range Md5 :echo system('echo '.shellescape(join(getline(<line1>, <line2>), '\n')) . '| md5')

"-------------------------------------------------------------------------------
" MACVIM
"-------------------------------------------------------------------------------
if has("gui_macvim")
  " Press Ctrl-Tab to switch between open tabs (like browser tabs) to 
  " the right side. Ctrl-Shift-Tab goes the other way.
  noremap <C-Tab> :tabnext<CR>
  noremap <C-S-Tab> :tabprev<CR>

  " Switch to specific tab numbers with Command-number
  noremap <D-1> :tabn 1<CR>
  noremap <D-2> :tabn 2<CR>
  noremap <D-3> :tabn 3<CR>
  noremap <D-4> :tabn 4<CR>
  noremap <D-5> :tabn 5<CR>
  noremap <D-6> :tabn 6<CR>
  noremap <D-7> :tabn 7<CR>
  noremap <D-8> :tabn 8<CR>
  noremap <D-9> :tabn 9<CR>
  noremap <D-0> :tabn 10<CR>
endif
