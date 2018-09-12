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
"Plugin 'tpope/vim-fugitive' "git
Plugin 'ntpeters/vim-better-whitespace' "Shows whitespace in annoying colors
Plugin 'airblade/vim-gitgutter' "Adds a gutter bar beside the line numbers indicating git changes
Plugin 'luochen1990/rainbow' "rainbow parenthesis
Plugin 'kien/ctrlp.vim' "fuzzy search

Plugin 'roxma/nvim-yarp' "More complete
Plugin 'roxma/vim-hug-neovim-rpc' "More completion
Plugin 'Shougo/deoplete.nvim' "Total completion
Plugin 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'make release'} "LSP support for deoplete

"Plugin 'vim-syntastic/syntastic' "syntastic is a syntax checking for multiple languages
"Plugin 'fatih/vim-go' "go lang plugin
"Plugin 'mdempsky/gocode', {'rtp': 'vim/'} "go autocomplete
"Plugin 'l04m33/vlime', {'rtp': 'vim/'} "Extra syntax for lisp languages
"Plugin 'artur-shaik/vim-javacomplete2' "java autocomplete

" Plugin 'ervandew/supertab' "Supertab is a vim plugin which allows you to use <Tab> for all your insert completion
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
let g:LanguageClient_serverCommands = {'java': ['/home/so/Workshop/java-lsp.sh'],}

"syntastic settings
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let g:syntastic_go_checkers = [] "Disable go since we are using vim-go instead
"let g:syntastic_java_checkers = ['javac']
"let g:syntastic_java_javac_config_file_enabled = 1
"let g:syntastic_c_include_dirs = ['/usr/include', '/usr/local/include',
"      \ '/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-7.b13.fc28.x86_64/include/',
"      \ '/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.181-7.b13.fc28.x86_64/include/linux/',
"      \ '/usr/include/curl/']
"let g:syntastic_python_checkers = ['pylint']

"tagbar settings
let g:tagbar_map_showproto = 'P'

"vim-go settings
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck']
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_metalinter_deadline = "5s"

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
