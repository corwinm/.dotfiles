" Standalone fallback for stock Vim. No plugins or external tools required.
set nocompatible
let mapleader = ' '
let maplocalleader = ' '

if has('syntax')
  syntax enable
endif
filetype plugin indent on

set number
if exists('+relativenumber')
  set relativenumber
endif
set cursorline
" Catppuccin-like line numbers and a gray active line, without underlining.
function! s:LineNumberColors() abort
  highlight LineNr term=NONE cterm=NONE ctermfg=DarkGray ctermbg=NONE gui=NONE guifg=#8087a2 guibg=NONE
  if &background ==# 'light'
    highlight CursorLine term=NONE cterm=NONE ctermfg=NONE ctermbg=LightGray gui=NONE guifg=NONE guibg=#e4e4e4
    if &t_Co >= 256
      highlight CursorLine ctermbg=254
    endif
    highlight CursorLineNr term=bold cterm=bold ctermfg=Black ctermbg=NONE gui=bold guifg=#4c4f69 guibg=NONE
  else
    highlight CursorLine term=NONE cterm=NONE ctermfg=NONE ctermbg=DarkGray gui=NONE guifg=NONE guibg=#303030
    if &t_Co >= 256
      highlight CursorLine ctermbg=236
    endif
    highlight CursorLineNr term=bold cterm=bold ctermfg=White ctermbg=NONE gui=bold guifg=#cad3f5 guibg=NONE
  endif
  highlight! link LineNrAbove LineNr
  highlight! link LineNrBelow LineNr
endfunction
augroup fallback_line_numbers
  autocmd!
  autocmd ColorScheme * call <SID>LineNumberColors()
  if exists('##OptionSet')
    autocmd OptionSet background call <SID>LineNumberColors()
  endif
augroup END
call s:LineNumberColors()

" Neovim-style cursor shapes in common terminals: block, bar, underline.
if !has('gui_running') && &term =~# 'xterm\|screen\|tmux\|rxvt\|ghostty'
  let &t_EI = "\<Esc>[2 q"
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_ti .= "\<Esc>[2 q"
  let &t_te .= "\<Esc>[0 q"
endif

set scrolloff=10
set showmode showcmd ruler
set laststatus=2
set backspace=indent,eol,start
set hidden confirm
set mouse=a
set splitright splitbelow
set ignorecase smartcase incsearch hlsearch
set timeoutlen=300
set wildmenu wildmode=longest:full,full

" Match the Neovim defaults; filetype indentation may override these.
set tabstop=4 softtabstop=4 shiftwidth=4
set noexpandtab autoindent
set list listchars=tab:>-,trail:.,nbsp:+
if exists('+breakindent')
  set breakindent
endif
if has('folding')
  set foldmethod=indent foldlevel=99
endif

" Use the system clipboard only when compiled in (often absent on servers).
if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  endif
  nnoremap <leader>y "+y
  xnoremap <leader>y "+y
  nnoremap <leader>Y "+Y
else
  nnoremap <leader>y y
  xnoremap <leader>y y
  nnoremap <leader>Y Y
endif

nnoremap <silent> <Esc> :nohlsearch<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>d "_d
xnoremap <leader>d "_d

nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l
nnoremap <silent> <C-\> <C-w>p
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap J :move '>+1<CR>gv=gv
xnoremap K :move '<-2<CR>gv=gv
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zz

" Built-in replacements for Oil and file/buffer pickers.
" netrw ships with standard Vim runtimes; '-' opens this file's directory.
let g:netrw_bufsettings = 'noma nomod number nobl nowrap ro'
if exists('+relativenumber')
  let g:netrw_bufsettings .= ' relativenumber'
endif
nnoremap <silent> - :Explore<CR>
set path+=**
set wildignore+=*/.git/*,*/node_modules/*,*/.venv/*
nnoremap <leader>sf :find<Space>
nnoremap <leader><leader> :ls<CR>:buffer<Space>
