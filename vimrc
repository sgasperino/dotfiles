set number
set linebreak
set showbreak=+++
set textwidth=100
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch

set autoindent
set expandtab
set shiftwidth=4
set smartindent
set smarttab
set softtabstop=4

set ruler
set clipboard=unnamed

set undolevels=1000
set backspace=indent,eol,start
:imap jj <Esc>
if has("autocmd")
  "" PUPPET
  autocmd BufNewFile,BufRead *.pp setfiletype puppet
  autocmd BufNewFile,BufRead *.pp set shiftwidth=2 softtabstop=2 filetype=puppet
endif
