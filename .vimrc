""""""""""""""""""""""""""""""
" INFO
""""""""""""""""""""""""""""""
" Plugins Used:
"     > surround.vim - http://www.vim.org/scripts/script.php?script_id=1697
"       Makes it easy to work with surrounding text.
"           info -> :help surround
"
"     > rails.vim - https://github.com/tpope/vim-rails 
"                OR http://www.vim.org/scripts/script.php?script_id=1567
"       Rails goodness.
"           info -> :help rails
"
"     > NERD_tree.vim - http://www.vim.org/scripts/script.php?script_id=1658
"                    OR https://github.com/scrooloose/nerdtree
"       File browser.
"           info -> :help NERD_tree.txt
"
"     > scrnpipe.vim - http://www.vim.org/scripts/script.php?script_id=3507
"                   OR https://github.com/bundacia/ScreenPipe 
"       Send selected text to another screen.
"
"     > snipmate.vim - http://www.vim.org/scripts/script.php?script_id=2540
"                   OR git://github.com/msanders/snipmate.vim.git
"       Snippet expansion like in TextMate
"           info -> :help snipMate
"
"       Installed snippets from https://github.com/scrooloose/snipmate-snippets:
"         git clone git://github.com/scrooloose/snipmate-snippets.git
"         cd snipmate-snippets
"         rake deplo_local
"
"     > netrw.vim - http://www.vim.org/scripts/script.php?script_id=1075
"       Open/Read/Write files over a network
"           info -> :help netrw
"
"     > pathogen.vim - http://www.vim.org/scripts/script.php?script_id=2332
"         allow installing of plugins in .vim/bundles
"
" After Installing Plugind:
"     try the folowwing to load the help pages:
"         :helptags ~/.vim/doc
"
"
""""""""""""""""""""""""""
" => Add pathogen bundles
""""""""""""""""""""""""""
call pathogen#runtime_append_all_bundles() 

""""""""""""""""""""""
" => Set the leader
""""""""""""""""""""""
let mapleader = ","

""""""""""""""""""""""
" => Persistent undo 
""""""""""""""""""""""
" wrap in try since it needs vim >=7.3 to work
try
    set undodir=~/.vim_custom/undo
    set undofile
catch
endtry

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => snipmate
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:snips_author = 'Trevor Little'
source ~/.vim/snippets/support_functions.vim

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERD_tree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <C-N> :NERDTreeToggle<CR>
let NERDTreeQuitOnOpen = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu "Turn on WiLd menu

set ignorecase "Ignore case when searching

set smartcase  "search case sensitive if search string contains uppercase letters

set hlsearch  "Highlight search term

set showmatch "Show matching bracets when text indicator is over them
set mat=2     "How many tenths of a second to blink
        
" ---- Tabs (whitespace) ---- "
set softtabstop=4 "An indentation level every 4 columns"
set expandtab     "Convert all tabs typed into spaces"
set shiftwidth=4  "Indent/Outdent by 4 columns"
set shiftround    "Always Indent/Outdent to the nearest tabstop"
set smartindent   "smart, automatic indendation
set autoindent

" make tab in v mode ident code
vmap <tab> >gv
vmap <S-tab> <gv

" make tab in normal mode ident code
nmap <tab> >><esc>
nmap <s-tab> <<

" don't require a save before switching buffers
set hidden
" press f5 to list and select buffers
nnoremap <F5> :buffers<CR>:buffer<Space>

" highlight row and col or cursor
au WinLeave * set nocursorline
au WinEnter * set cursorline
set cursorline

" ---- Windows ---- "
"set noea "Don't equalize each window when a new one is opened or closed"

set modeline " respect modelines 

set ofu=syntaxcomplete#Complete

" ---- syntax highlighting --- "
syn on
setglobal t_Co=256 " my term can do 256 colors

filetype plugin on
filetype indent on

set backspace=indent,eol,start  " allow backspacing over eevrything in insert mode

""""""""""""""""""""""
" => Coloring
""""""""""""""""""""""
" using solorized from http://ethanschoonover.com/solarized
set background=dark
colorscheme solarized

" but make comments and search greys
"hi Comment	ctermfg=241
"hi Search	ctermbg=244

""""""""""""""""""""""
" Align
""""""""""""""""""""""

" align "words" (=>, #, :, etc)  vertically
" relies on a script named 'align' in the path.
function! Align() 
    " Mark cursor position as 's', then yank word
    normal msyw
    " Call align with the current word
    execute ".,$!align " . shellescape(@")
    " Restore cursor position
    normal `s
endfunction

function! AlignHash() 
    " Mark cursor position
    normal ms
    " Call align with => and ,
    execute ".,$!align '=>' ,"
    " Restore cursor position
    normal `s
endfunction

map ,a :call Align()<CR>
map ,A :call AlignHash()<CR>

""""""""""""""""""""""
" => Ruby editing
""""""""""""""""""""""
" 2-space tabs for ruby files
autocmd FileType ruby,eruby,yaml,haml,scss set shiftwidth=2 softtabstop=2 expandtab
map T :w<CR>:!bundle exec rspec %:<C-R>=line('.')<CR><CR>
"autocmd FileType ruby,eruby,yaml,haml,scss colorscheme vividchalk

""""""""""""""""""""""
" => Perl editing
""""""""""""""""""""""
"use desert for perl
"autocmd FileType perl colorscheme desert
" and tweak pod highlighting
autocmd FileType perl hi link podCommand      Comment
autocmd FileType perl hi link podCmdText      Character
autocmd FileType perl hi link podOverIndent   Number
autocmd FileType perl hi link podForKeywd     Tag
autocmd FileType perl hi link podFormat       Tag
autocmd FileType perl hi link podVerbatimLine Structure
autocmd FileType perl hi link podSpecial      Tag
autocmd FileType perl hi link podEscape       String
autocmd FileType perl hi link podEscape2      Number

nmap <C-D>  iuse Data::Dumper 'Dumper'; warn Dumper [];#DEBUG#8hi
"nmap <C-B>  iBugzID: 

let perl_include_pod = 1
let perl_extended_vars = 1

" mason syntax highlighting
au syntax mason so /usr/local/share/vim/vim71/syntax/mason.vim
au BufNewFile,BufRead *.tpl set ft=mason
nnoremap M :set filetype=mason<RETURN>

""""""""""""""""""""""
" => RELOAD
""""""""""""""""""""""
" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
