""""""""""""""""""""""""""""""
" INFO
""""""""""""""""""""""""""""""
" Plugins Used:
"     > surround.vim - http://www.vim.org/scripts/script.php?script_id=1697
"       makes it easy to work with surrounding text.
"           info -> :help surround
"
"     > rails.vim - https://github.com/tpope/vim-rails
"                or http://www.vim.org/scripts/script.php?script_id=1567
"       rails goodness.
"           info -> :help rails
"
"     > nerd_tree.vim - http://www.vim.org/scripts/script.php?script_id=1658
"                    or https://github.com/scrooloose/nerdtree
"       file browser.
"           info -> :help nerd_tree.txt
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
"     > syntastic - https://github.com/scrooloose/syntastic
"         Error checking for lots if different filetypes
"
"     > ack - http://www.vim.org/scripts/script.php?script_id=2572
"         arep your working tree with ack from within vim
"
" After Installing Plugind:
"     try the folowwing to load the help pages:
"         :helptags ~/.vim/doc
"
"
""""""""""""""""""""""""""
" => Add pathogen bundles
""""""""""""""""""""""""""
call pathogen#infect()
"call pathogen#runtime_append_all_bundles()


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
" => ack
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ackprg='ack-grep -H --nocolor --nogroup --column'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => snipmate
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:snips_author = 'Trevor Little'
source ~/.vim/snippets/support_functions.vim
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => syntastic
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" check syntax on save, but not for cucumber files
"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['cucumber'] }

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Make C-a go home in cmd mode like in bash
cnoremap <C-a>  <Home>

" ,, to unhilight searches
nmap ,, :nohlsearch<CR>

set wildmenu "Turn on WiLd menu

set ignorecase "Ignore case when searching

set smartcase  "search case sensitive if search string contains uppercase letters

set hlsearch  "Highlight search term

set showmatch "Show matching bracets when text indicator is over them
set mat=2     "How many tenths of a second to blink

set number    "Line Numbers

set backspace=indent,eol,start  " allow backspacing over eevrything in insert mode

set dictionary+=/usr/share/dict/words " set dictionary for word completion

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
" NOTE: uncommenting this will remap C-I as well since vim sees them as the same thing =)
"nmap <tab> >>
"nmap <s-tab> <<

" made tilde work like an operator
set tildeop

" don't require a save before switching buffers
set hidden

set modeline " respect modelines

set ofu=syntaxcomplete#Complete

" ---- syntax highlighting --- "
syn on
setglobal t_Co=256 " my term can do 256 colors

filetype plugin on
filetype indent on

""""""""""""""""""""""
" => Coloring
""""""""""""""""""""""
" using solorized from http://ethanschoonover.com/solarized
set background=dark
colorscheme solarized

""""""""""""""""""""""
" => Whitespace
""""""""""""""""""""""
" highlight empty space at the end of a line
autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@!$/
autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
highlight EOLWS ctermbg=red guibg=red

function! <SID>StripTrailingWhitespace()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
nmap <silent> <leader><space> :call <SID>StripTrailingWhitespace()<CR>

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

map <leader>a :call Align()<CR>
map <leader>A :call AlignHash()<CR>

""""""""""""""""""""""
" => Ruby editing
""""""""""""""""""""""
" 2-space tabs for ruby files
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber set shiftwidth=2 softtabstop=2 expandtab
" Swap strings and symbols
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>' xysw'
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>: ds'i:
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>H i:f:xi =>F:
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>h xf r:ldf>F l
" Run tests
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>t :call RunTestCommand(line('.'))<CR>
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>T :call RunTestCommand()<CR>

function! GetTestCommand()
    if expand('%:r') =~ '_spec$'
        return 'bundle exec rspec'
    elseif expand('%') =~ '\.feature$'
        return 'bundle exec cucumber'
    else
        return '0'
    endif
endfunction

function! RunTestCommand(...)
    let cmd = GetTestCommand()

    " if there's a command update the test command register (t)
    if cmd != '0'
        let @t = ':!' . cmd . ' ' . expand('%') . (a:0 == 1 ? ':'.line('.') : '')
    endif

    " if the test command register isn't empty, excecute it.
    if strlen(@t) > 0
        execute @t
    elseif
        echoerr "No test command to run"
    end

endfunction

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

let perl_include_pod = 1
let perl_extended_vars = 1

""""""""""""""""""""""
" => RELOAD
""""""""""""""""""""""
" When vimrc is edited, reload it
autocmd! bufwritepost .vimrc source ~/.vimrc
