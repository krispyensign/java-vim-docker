set nocompatible              " be iMproved, required
syntax on
set encoding=utf8

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree' "self explanatory
Plugin 'majutsushi/tagbar' "Needs Universal C-Tags.  Provides an easy way to browse the tags of the current file and get an overview of its structure.
Plugin 'toadjaune/nerdtree-git-plugin' "Shows git marks in NerdTree
Plugin 'flazz/vim-colorschemes' "all my color schemes to make vim look like atom
Plugin 'vim-airline/vim-airline' "slick bar
Plugin 'ntpeters/vim-better-whitespace' "Shows whitespace in annoying colors
Plugin 'airblade/vim-gitgutter' "Adds a gutter bar beside the line numbers indicating git changes
Plugin 'luochen1990/rainbow' "rainbow parenthesis
Plugin 'kien/ctrlp.vim' "fuzzy search

Plugin 'roxma/nvim-yarp' "More complete
Plugin 'roxma/vim-hug-neovim-rpc' "More completion
Plugin 'Shougo/deoplete.nvim' "Total completion
Plugin 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'make release'} "LSP support for deoplete
call vundle#end()

set t_ut=
set background=dark
colorscheme onedark
set nowrap
set tabstop=2
set shiftwidth=2
set expandtab
set number
set foldmethod=indent
set foldnestmax=10
set nofoldenable
set foldlevel=2
filetype plugin indent on

if (exists('+colorcolumn'))
  set colorcolumn=120
  highlight ColorColumn ctermbg=9
endif

"Rainbow settings
let g:rainbow_active = 1
let g:rainbow_conf = { 'ctermfgs': [27, 142, 'magenta', 'cyan'] }

"airline settings
let g:airline_powerline_fonts = 1

"Deoplete configurations
let g:deoplete#enable_at_startup = 1

"LanguageClient settings
let g:LanguageClient_serverCommands = {'java': ['/home/vimuser/bin/java-lsp.sh'],}

"tagbar settings
let g:tagbar_map_showproto = 'P'

"my mappings
let mapleader = ' '
nnoremap <silent> <leader><Up> :wincmd k<CR>
nnoremap <silent> <leader><Down> :wincmd j<CR>
nnoremap <silent> <leader><Left> :wincmd h<CR>
nnoremap <silent> <leader><Right> :wincmd l<CR>
nnoremap <silent> <leader>[ :vertical resize +5<CR>
nnoremap <silent> <leader>] :vertical resize -5<CR>
nnoremap <silent> <leader>n :NERDTreeToggle<CR>
nnoremap <silent> <leader>t :TagbarToggle<CR>
