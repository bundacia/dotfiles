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
"     > ack - http://www.vim.org/scripts/script.php?script_id=2572
"         arep your working tree with ack from within vim
"
"     > GitGutter - https://github.com/airblade/vim-gitgutter
"         Show modified/added/deleted lines in sign column
"
"     > commentary - https://github.com/tpope/vim-commentary
"         Comment shortcuts for different file types
"
"     > threesome - http://sjl.bitbucket.org/threesome.vim/
"         vim diff tool 
"
"     > tslime - https://github.com/jgdavey/tslime.vim
"         Send commands to another tmux session/window/pane
"
" After Installing Plugind:
"     try the folowwing to load the help pages:
"         :helptags ~/.vim/doc
"

""""""""""""""""""""""""""
" => Setup shell for :!
""""""""""""""""""""""""""
" this makes it use an interactive shell so that the .zshrc
" file gets sourced and all my aliases and stuff are present.
"BROKEN!"set shell=zsh\ -i

""""""""""""""""""""""""""
" => Add pathogen bundles
""""""""""""""""""""""""""
call pathogen#infect()
"call pathogen#runtime_append_all_bundles()


""""""""""""""""""""""
" => Set the leaders
""""""""""""""""""""""
let mapleader = ","
let maplocalleader = "\\"

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
" let g:ackprg='ack-grep -H --nocolor --nogroup --column'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => snipmate
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:snips_author = 'Trevor Little'
source ~/.vim/snippets/support_functions.vim

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
" GitGutter
""""""""""""""""""""""
" clear signcolumn so that gitgutter will use the LineNr color
highlight SignColumn ctermbg=0
highlight GitGutterAdd          ctermfg=2           ctermbg=0 " an added line
highlight GitGutterChange       ctermfg=brown       ctermbg=0 " a changed line
highlight GitGutterDelete       ctermfg=darkred     ctermbg=0 " at least one removed line
highlight GitGutterChangeDelete ctermfg=lightyellow ctermbg=0 " a changed line followed by at least one removed line
" Only update when reading or writing a file
let g:gitgutter_eager = 0

""""""""""""""""""""""
" => Whitespace
""""""""""""""""""""""
" highlight empty space at the end of a line
" autocmd InsertEnter * syn clear EOLWS | syn match EOLWS excludenl /\s\+\%#\@<!$/
" autocmd InsertLeave * syn clear EOLWS | syn match EOLWS excludenl /\s\+$/
" highlight EOLWS ctermbg=red guibg=red

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
    execute ".,$!align '=' ,"
    " Restore cursor position
    normal `s
endfunction

map <leader>a :call Align()<CR>
map <leader>A :call AlignHash()<CR>

""""""""""""""""""""""
" Underscore
""""""""""""""""""""""
" convert CamelCase words to Underscore
" relies on a script named 'underscore' in the path.
function! Underscore()
    " Mark cursor position
    normal ms
    " hilight the current word
    normal viw
    " Call underscore
    execute "'<,'>!underscore "
    " Restore cursor position
    normal `s
endfunction

map <leader>u :call Underscore()<CR>

""""""""""""""""""""""
" => Ruby editing
""""""""""""""""""""""
" 2-space tabs for ruby files (and js)
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber,javascript set shiftwidth=2 softtabstop=2 tabstop=2 expandtab
" Swap strings and symbols
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>' xysw'
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>: ds'i:
" Swap `:key => value` for `key: value` and back
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>H i:f:xi =>F:
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <leader>h xf r:ldf>F l
" Run tests
" autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <silent> <leader>t :call RunTestCommand(line('.'))<CR>
" autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <silent> <leader>T :call RunTestCommand()<CR>
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <silent> <leader>t :call RunTestCommandInTmux(line('.'))<CR>
autocmd FileType ruby,eruby,yaml,haml,scss,cucumber nmap <silent> <leader>T :call RunTestCommandInTmux()<CR>

" Get :A to work for javascript files (from https://github.com/tpope/vim-rails/issues/142)
autocmd User Rails/app/assets/javascripts/*/*.js,Rails/app/assets/javascripts/*.js let b:rails_alternate = substitute(substitute(rails#buffer().path(), 'app/assets', 'spec', ''), '\.js', '_spec.js', '')
autocmd User Rails/spec/javascripts/*/*.js,Rails/spec/javascripts/*.js let b:rails_alternate = substitute(substitute(rails#buffer().path(), 'spec/javascripts', 'app/assets/javascripts', ''), '_spec\.js', '.js', '')

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

function! RunTestCommandInTmux(...)
    let cmd = GetTestCommand()

    " if there's a command update the test command register (t)
    if cmd != '0'
        let @t = "call SendToTmux('cd " . getcwd() . "; clear;date;" . cmd . ' ' . expand('%') . (a:0 == 1 ? ':'.line('.') : '') . "')"
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
