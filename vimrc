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
" CTRL-P
"-------------------------------------------------------------------------------
" Easy access to the Ctrl-P buffer finder
nmap ; :CtrlPBuffer<CR>
" Override default Ctrl-P key
let g:ctrlp_map = '<leader>t'
let g:ctrlp_custom_ignore = 'node_modules\|bower_components\|DS_Store\|git'

"-------------------------------------------------------------------------------
" SYNTASTIC
"-------------------------------------------------------------------------------
let g:syntastic_html_tidy_ignore_errors = [' proprietary attribute ', 'trimming empty <']

"-------------------------------------------------------------------------------
" NERDTREE
"-------------------------------------------------------------------------------
nmap <leader>e :NERDTreeToggle<CR>

"-------------------------------------------------------------------------------
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
"-------------------------------------------------------------------------------
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

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
" OpenChangedFiles COMMAND
" Open a split for each dirty file in git
"-------------------------------------------------------------------------------
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()

"-------------------------------------------------------------------------------
" InsertTime COMMAND
" Insert the current time
"-------------------------------------------------------------------------------
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>
