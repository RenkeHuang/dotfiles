" Configuration file for vim
syntax on
set background=dark
filetype plugin indent on
set number
set cursorline
set scrolloff=3
set hlsearch
set foldmethod=indent
set foldlevel=99
set autoindent
set expandtab
set softtabstop=4
set shiftwidth=4
set mouse=a
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction
