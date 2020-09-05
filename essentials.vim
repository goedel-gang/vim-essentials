" vim: ai fdl=0 fdm=marker fmr={{{,}}}

"                                          __   .__         .__
"   ____    ______  ______  ____    ____ _/  |_ |__|_____   |  |    ______
" _/ __ \  /  ___/ /  ___/_/ __ \  /    \\   __\|  |\__  \  |  |   /  ___/
" \  ___/  \___ \  \___ \ \  ___/ |   |  \|  |  |  | / __ \_|  |__ \___ \
"  \___  >/____  >/____  > \___  >|___|  /|__|  |__|(____  /|____//____  >
"      \/      \/      \/      \/      \/                \/            \/
" FIGMENTIZE: essentials

" The idea of this file is to be a complete vimrc containing the bare essentials
" for a good quality-of-life experience with editing in Vim. It only executes
" vanilla Vim by default, with some control structures that try to accommodate
" different versions of Vim, somewhat. There is an optional section to do with
" plugins at the end.

" This file consists mostly of annotated excerpts from what was my vimrc at the
" time of writing.

" This is according to my own personal definition of "essential". Other users
" may wish to remove more.

" Below are some sections. Hopefully, they have been folded. You can see what's
" inside them by standing on one and typing zo. You can close a fold again with
" zc, or you can close them all with zM, or open them all with zR.

" You can launch a demonstrative vim instance editing this file that uses this
" file as vimrc, by typing "make".

" {{{ PREAMBLE

set encoding=utf-8

" leave the heathens to their folly. Prevent evim from loading full config for
" compatibility reasons.
if v:progname =~? "evim"
    finish
endif

" Avoid side effects ONLY IF `nocp` already set. THIS IS CRUCIALLY IMPORTANT
" Basically everything breaks if you don't do this
" setting nocompatible is very important as it's no longer 1970. This makes Vim
" stop trying to be compatible with vi
if &compatible
    set nocompatible
endif

" colour-related options, wrapped in some conditions just to be on the safe side
if &t_Co > 2 || has("gui_running")
    syntax enable
    " do not set hlsearch if it is already set, as this will annoyingly
    " re-highlight searches if you've set :noh
    if !&hlsearch
        set hlsearch
    endif
endif

" Basically, let vim load plugins (from the standard Vim runtime) for filetypes.
" This is pretty essential to any vim user's quality of life. This enables
" features like automatic disabling of 'expandtab' in Makefiles, and automatic
" indentation after the start of a function or if statement in programming
" languages. Also lets you use "K" on keywords in a Vim file, for example.
filetype plugin indent on

if has("patch-8.0.1708")
    " make useful directories in ~/.vim where they don't exist
    call mkdir($HOME . "/.vim", "p")
    for dirname in split("backups swap spell undo")
        call mkdir($HOME . "/.vim/" . dirname, "p")
    endfor
else
    function! MKDirP(dirname) abort
        if !isdirectory(a:dirname)
            call mkdir(a:dirname, "p")
        endif
    endfunction
    call MKDirP($HOME . "/.vim")
    for dirname in split("backups swap spell undo")
        call MKDirP($HOME . "/.vim/" . dirname)
    endfor
endif

" name and shame trailing whitespace:          
highlight TrailingWhitespace ctermbg=red guibg=red
augroup TrailingWhitespaceMatch
    autocmd! VimEnter,WinEnter * match TrailingWhitespace /\s\+$/
augroup END

" }}}

" {{{ OPTIONS

" enable modelines, for backwards systems like MacOS that disable them by
" default. Enables vim to read extra configurations from the start of a file
" you're editing. See line 1 for an example of a modeline enabling 'ai' and
" folding.
set modeline
set modelines=5

" Write backup files. Disk is cheap, write speeds are fast, and you never know.
set backup
set writebackup
set backupdir=~/.vim/backups

" Keep swap files out of the way
set directory^=~/.vim/swap

" save 10000 levels of undo
set undolevels=10000
" cache entire buffers under 10000 lines
set undoreload=10000

" Persistent undo history written
set undofile
set undodir=~/.vim/undo

" Preserve vim state:
" (lack of %): don't store bufferlist. This means that vim with no arguments
"              opens cleanly, which is nicer generally because sometimes you get
"              weird tempfiles from git commits or command line editing. I
"              automatically write session files to ~/.vim/sessions/auto as
"              well, which provide the functionality of un-closing a vim with a
"              precious bufferlist (among other things). See
"              $ZDOTDIR/goedel_aliases.sh
" '10000: store marks for 10000 previously edited files
" /10000: store 10000 previous searches
" :10000: store 10000 previous commands issued
" <1000000: store at most 1000000 lines of each register
" @100000: store 100000 lines of input-line history
" s10000: allow items to be 10000 Kbyte in size
set viminfo='10000,/10000,:10000,<1000000,s10000,@10000,h,n~/.vim/viminfo

" remember 10000 lines of command-line history in memory
set history=10000

" spellcapcheck set to nothing stops vim from whining about capitalisation in
" the middle of sentences.
set spellcapcheck=
set spell
" You should interactively do `:set spelllang=nl spell`. Then hopefully Vim will
" download a Dutch spellfile for you, and then you can uncomment this line.
" set spelllang=en_gb,nl

" Make bad spellings be highlighted a bit more gently
highlight clear SpellBad
highlight clear SpellRare
highlight clear SpellLocal
highlight clear SpellCap
highlight SpellBad term=reverse cterm=undercurl gui=undercurl
highlight SpellRare term=reverse cterm=undercurl gui=undercurl
highlight SpellLocal term=reverse cterm=undercurl gui=undercurl
highlight SpellCap term=reverse cterm=undercurl gui=undercurl

" also nicely highlight closed folds
highlight clear Folded
highlight Folded term=underline ctermbg=237 guibg=#3c3836

" Keep 5 lines and 10 cols of context on the screen
set scrolloff=5
set sidescrolloff=10
" When walking off the screen, jump 5 rows or 10 columns at a time. This
" prevents too many redraws when you're making small movements near the edge of
" the screen.
set scrolljump=5
set sidescroll=10


" display current cursor position
set ruler
" display long normal-mode commands as they're typed
set showcmd
" show matches for a search live as you type them
set incsearch
" let visual block mode go off the end
set virtualedit=block

" these options provide a kind of crosshair on the cursor. It looks kind of cool
" and can be useful to snap your vision to the cursor, but it can also cause
" slower redrawing.
set cursorline
set cursorcolumn
highlight clear CursorLine
highlight clear CursorColumn
highlight CursorColumn term=underline ctermbg=237 guibg=#3c3836
highlight CursorLine term=underline ctermbg=237 guibg=#3c3836

" delays for mappings and keycodes
" make <Esc> work with minimal delay.
set timeout
set nottimeout
" make there be effectively no timeout for mappings
" god help you if you take 100 seconds to type out a mapping
set timeoutlen=100000
" make keycodes (like Escape) be really fast
set ttimeoutlen=10

" prevent langmap from messing up mappings, if you have a multilingual keyboard.
if has('langmap') && exists('+langnoremap')
    set langnoremap
endif

" line numbers, that are relative to current line
" allegedly lets you judge repetitions of movement commands, and it looks cool
" the set number means that the absolute current line number *is* displayed, but
" the rest are relative.

" Also, they're made absolute again when you go back into insert mode. I think
" that's kind of cool but I don't know if I'll keep it.
set number
set relativenumber

" whitespace
" tab = 4 spaces, and various associated options
set autoindent
set expandtab
set tabstop=4
set shiftwidth=0
set softtabstop=-1
set shiftround

" when joining lines with ",", don't add 2 spaces after punctuation.
set nojoinspaces

" t: wrap text at text width
" c: autowrap comments
" q: be clever about formatting comments with gq
" j: be clever about formatting comments with J
" r: add a new comment leader when <CR> hit in a comment
" o: add a new comment leader when o hit in normal mode
" n: be clever about formatting numbered lists.
"
" Demo: Try un-wrapping some of the below list items and then using "gq" on
" them.
"    1. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
"       tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
"    2. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
"       tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
"   - Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
"     tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
"     + Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
"       tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
"       * Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
"         eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad
"   FIXME: Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
"          eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
"      TODO: Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
"            eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim
"            ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut
"           PS: Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
"               eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut
"               enim ad minim veniam, quis nostrud exercitation ullamco laboris
"               nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor
"               in reprehenderit in voluptate velit esse cillum dolore eu fugiat
"               nulla pariatur. Excepteur sint occaecat cupidatat non proident,
"               sunt in culpa qui officia deserunt mollit anim id est laborum.
"   (see also: set formatlistpat)
" l: do not break a line that was already too long before insertion
set formatoptions+=tcqjronl

" this makes the vim auto-formatting with "gq" recognise unordered 'bullet
" point' lists using -+*, in addition to the default ordered lists with numbers
" Also, indent things after a TODO more nicely
set formatlistpat=^\\s*\\d\\+[\\]:.)}\\t\ ]\\s*\\\|^\\s*[-+*]\\s*\\\|^\\s*\\%(TODO\\\|FIXME\\\|PS\\)[:]\\?\\s*

" tell Vim to assume that tex files are latex, by default
let g:tex_flavor = 'latex'

" Do not treat '=' as part of a file-name when using gf or ^X^F. Useful in shell
" scripts and vim scripts where you write variable=filename a lot.
set isfname-==

" shorten certain types of diagnostic/informational messages more (eg [w]
" instead of "written" after you do :w)
set shortmess=atToO

" when incrementing & decrementing with ^A, ^X, increment binary numbers and
" hexadecimal numbers like 0b101 and 0xfa correctly. Incrementing alphabetic
" characters shifts them forwards or backwards in the alphabet.
set nrformats=bin,hex,alpha

" name and shame any actual tabs. Lets you visually distinguish between tabs and
" spaces. Here: 	 is a tab.
set list
if has("patch-8.1.0759")
    set listchars=tab:<->
else
    set listchars=tab:>-
endif

" show hex characters as codes. If you open a binary file, this makes the ^@s
" more intelligible.
set display+=uhex

" text width is 80 for formatting purposes. Visually demarcate it.
set textwidth=80
set colorcolumn=+1
highlight ColorColumn term=underline ctermbg=237 guibg=#3c3836

" Settings for soft line wrapping. This means that if you have a line in your
" source that's actually long, it's broken legibly and you get a little
" indication that there's a break.
"
" Demonstrative long line: Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Ut purus elit, vestibulum ut, placerat ac, adipiscing vitae, felis. Curabitur dictum gravida mauris. Nam arcu libero, nonummy eget, consectetuer id, vulputate a, magna. Donec vehicula augue eu neque. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Mauris ut leo. Cras viverra metus rhoncus sem. Nulla et lectus vestibulum urna fringilla ultrices. Phasellus eu tellus sit amet tortor gravida placerat. Integer sapien est, iaculis in, pretium quis, viverra ac, nunc. Praesent eget sem vel leo ultrices bibendum. Aenean faucibus. Morbi dolor nulla, malesuada eu, pulvinar at, mollis ac, nulla. Curabitur auctor semper nulla. Donec varius orci eget risus. Duis nibh mi, congue eu, accumsan eleifend, sagittis quis, diam. Duis eget orci sit amet orci dignissim rutrum.
set linebreak
set breakindent
set display+=lastline
let &g:showbreak = "+++ "

" backspace, space, ~ can go between lines in normal/visual mode
set whichwrap=b,s,~,<,>,[,]

" Let backspaces in insert mode delete lines
set backspace=indent,eol,start

" ignore case in search
set ignorecase
" completion becomes case insensitive if it can't find anything sensitive
set smartcase
" Adjusts completed case to match
set infercase
" set good encryption
set cryptmethod=blowfish2

" Customise completion in command mode. Shows a completion menu, and ignores
" case.
set wildmenu
set wildignorecase
" Defer files ending in bad endings in the completion.
set suffixes+=*.pyc,*.swp,__pycache__,*.aux
" completion in insert-mode with <C-n> and <C-p> and the like can draw from
" other windows, buffers, unloaded buffers, tags, and imported files.
set complete=.,w,b,u,t,i

" Suffixes to try on the "gf" command. This lets me open \include{}-ed files or
" import-ed files.
set suffixesadd+=.tex,.sty,.bib,.cls,.py

" Change directory to file being edited. This just aligns with how I like to
" think, I suppose. It means that if you do :e, it's always relative to the file
" you're currently editing.
set autochdir

" keep buffers not in a window open in memory. preserves undo history for
" buffers etc
set hidden

" Automatically reload changed files if they've not been changed within Vim
set autoread

" confirmation dialogue when closing an unsaved file, or when quitting before
" you've opened every file. Instead of forcing you to type :q!, you can just
" type :q and then y.
set confirm

" Don't redraw as eagerly (eg during macro expansion)
set lazyredraw

" Make it so new buffers are opened going to the right and down. We live in a
" society.
set splitright
set splitbelow

" }}}

" {{{ DIGRAPHS

" In Vim, in insert mode, you can type some special characters by doing <C-k>
" followed by some keys. For example, <C-k>o: produces ö, and <C-k>FA produces
" ∀, and so on and so on. See :h digraphs-default for a full list of what's
" available by default. This adds some blackboard bold maths characters,
" prefixed with $ because that's how you start a math environment in TeX.

digraphs $A 120120 " 𝔸
digraphs $B 120121 " 𝔹
digraphs $C 8450 " ℂ
digraphs $D 120123 " 𝔻
digraphs $E 120124 " 𝔼
digraphs $F 120125 " 𝔽
digraphs $G 120126 " 𝔾
digraphs $H 8461 " ℍ
digraphs $I 120128 " 𝕀
digraphs $J 120129 " 𝕁
digraphs $K 120130 " 𝕂
digraphs $L 120131 " 𝕃
digraphs $M 120132 " 𝕄
digraphs $N 8469 " ℕ
digraphs $O 120134 " 𝕆
digraphs $P 8473 " ℙ
digraphs $Q 8474 " ℚ
digraphs $R 8477 " ℝ
digraphs $S 120138 " 𝕊
digraphs $T 120139 " 𝕋
digraphs $U 120140 " 𝕌
digraphs $V 120141 " 𝕍
digraphs $W 120142 " 𝕎
digraphs $X 120143 " 𝕏
digraphs $Y 120144 " 𝕐
digraphs $Z  8484 " ℤ

" }}}

" {{{ MAPPINGS

" Use space as the leader key. This key is used by plugins, and by you, to make
" custom longer mappings. By default it's set to be \ (backslash) which is
" frankly terrible. Space is much faster to type
noremap <Space> <Nop>
let mapleader = ' '
noremap g<Space> <Space>

" Repeated indentation in visual mode. Lets you select something and then do
" >><>>.
xnoremap > >gv
xnoremap < <gv

" Toggle Paste mode, by typing the leader key followed by p. Subsequently shows
" if paste mode is on or not.
nnoremap <Leader>p :set paste! <bar> set paste?<CR>

" Shortcut to turn highlighting off after a search.
nnoremap <CR> :nohlsearch<CR>
" However, in the command-line window I do want CR to be a normal CR, so I
" automatically unset and reset this mapping. (This part is important if you
" want the <CR> mapping.
augroup CmdWinCRRestore
    autocmd! CmdWinEnter * nnoremap <buffer> <CR> <CR>
augroup END

" make ctrl-c "abort" current insertion in insert mode. It's consistent with the
" characterisation of ctrl-c in unix lore, and sometimes you're just angry at
" what you've written, y'know
inoremap <C-c> <Esc>u

" map Y so it behaves like D and C
nnoremap Y y$

" automatically show more information with ^G. Careful not to bind this in
" mapmode-x, as there it is used to switch from [Visual] to [Selection]
nnoremap <C-g> 2<C-g>

" remap <C-n> and <C-p> to go between buffers or tabs, if available. (Their
" usual functionality is completely redundant, and this is a very convenient way
" to switch between buffers.)
function! CNTabCycle() abort
    if tabpagenr("$") == 1
        bnext
    else
        tabnext
        echom "Cycled to tab " . tabpagenr()
    endif
endfunction

function! CPTabCycle() abort
    if tabpagenr("$") == 1
        bprevious
    else
        tabprevious
        echom "Cycled to tab " . tabpagenr()
    endif
endfunction

nnoremap <C-n> :call CNTabCycle()<CR>
nnoremap <C-p> :call CPTabCycle()<CR>

" remap <C-[hjk]> to jump quickly between splits. they were useless anyway, and
" we store <C-l> in g<C-l>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" You can still redraw the screen with g<C-l>
nnoremap g<C-l> <C-l>

" You can free up <C-q> by putting `stty -ixon` in a shell rc file. Then this
" mapping lets you close a window by doing <C-q>.
" (Its normal functionality in a terminal is to unfreeze it after it's been
" frozen with <C-s>. This is very annoying so you should turn it off anyway).
nnoremap <C-q> <C-w>q

" select previously inserted text, in the spirit of gv
nnoremap gV `[v`]

" Make Q repeat the `qq` macro, rather than enter ex mode.
noremap Q @q
" Instead use gQ for ex-mode, discarding the weird fake ex-mode
noremap gQ Q

" A nice and easy mapping to close a buffer, without closing vim
nnoremap <Leader>q :bd<CR>

" A quick way to strip trailing whitespace. Select an area in visual mode, or
" go to a line in normal mode, and hit <Leader>s
nnoremap <Leader>s :.s/\s\+$//<CR>
xnoremap <Leader>s :s/\s\+$//<CR>

" easier window resizing with ^W+++++ and ------ and <<<<<< and >>>>>
" https://www.vim.org/scripts/script.php?script_id=2223
nmap <C-W>+ <C-W>+<SID>(wresize)
nmap <C-W>- <C-W>-<SID>(wresize)
nmap <C-W>> <C-W>><SID>(wresize)
nmap <C-W>< <C-W><<SID>(wresize)
nnoremap <script> <SID>(wresize)+ <C-W>+<SID>(wresize)
nnoremap <script> <SID>(wresize)- <C-W>-<SID>(wresize)
nnoremap <script> <SID>(wresize)> <C-W>><SID>(wresize)
nnoremap <script> <SID>(wresize)< <C-W><<SID>(wresize)
nnoremap <script> <SID>(wresize)= <C-W>=<SID>(wresize)
nmap <script> <SID>(wresize) <Nop>


" easier horizontal scrolling with zllllll and LLLL and hhh and HHHHH
" as seen in "easier window resizing". Try setting nowrap, and then using these.
nmap zh zh<SID>(hscroll)
nmap zl zl<SID>(hscroll)
nmap zH zH<SID>(hscroll)
nmap zL zL<SID>(hscroll)
nnoremap <script> <SID>(hscroll)h zh<SID>(hscroll)
nnoremap <script> <SID>(hscroll)l zl<SID>(hscroll)
nnoremap <script> <SID>(hscroll)H zH<SID>(hscroll)
nnoremap <script> <SID>(hscroll)L zL<SID>(hscroll)
nmap <script> <SID>(hscroll) <Nop>

" }}}

" {{{ COMMANDS

" Allow saving of files as sudo when I forgot to start vim using sudo.
" It tees the buffer into its name, silently, redirecting stdout to /dev/null,
" and then reloads the file.
"
" Basically, if you need sudo to write a file you have made changes to already,
" use :W
function! W() abort
    silent w !sudo tee > /dev/null %
    " reload file only if it was written successfully
    if v:shell_error == 0
        edit!
    else
        echohl ErrorMsg
        redraw | echomsg "Could not write file as root"
        echohl None
    endif
endfunction
command! W call W()


" command to insert output of ex command into buffer. For example, :Rcom smile.
command! -nargs=+ -complete=command Rcom call append(line("."), split(execute(<q-args>), "\n"))

command! MakeScratch setlocal buftype=nofile bufhidden=hide noswapfile nobuflisted
" command to redirect another command into a new buffer
" Opens in a scratch buffer so you can close it without being harassed. For
" example, :Redir smile
command! -nargs=+ -complete=command Redir new
            \ | call append(line("."), split(execute(<q-args>), "\n"))
            \ | MakeScratch

" }}}

" {{{ PLUGINS

" This part contains just a few of my most favourite plugins. If you have the
" ability to install a few plugins, I recommend doing so. To make this work
" properly, you should put the file autoload/plug.vim in
" ~/.vim/autoload/plug.vim. Then get rid of the runtimepath bit below, and make
" sure the following section is sourced somewhere in a vimrc. Then, in vim, type
" :PlugInstall

" Experimentally, if you run "make plug_demo", the following will be loaded
" anyway. Again, type :PlugInstall.

if $DO_PLUG_DEMO == "1"
    if has("patch-8.0.1708")
        call mkdir($HOME . "/.vim/bundle", "p")
    else
        call MKDirP($HOME . "/.vim/bundle")
    endif

    set runtimepath+=$PWD

    call plug#begin('~/.vim/bundle')

    " Plug plug itself in order to generate documentation for it. Lets you
    " :h vim-plug.
    Plug 'junegunn/vim-plug'

    " visualise the undo tree in a tree, rather than a flat list, using
    " :UndoTreeToggle
    Plug 'mbbill/undotree'

    " Text objects for indented blocks, with ii, iI, ai, aI
    Plug 'michaeljsmith/vim-indent-object'

    " nifty little plugin to show what the targets of f, t, F, T are.
    Plug 'unblevable/quick-scope'

    " better syntax highlighting for Python (eg f-strings)
    let g:python_highlight_all = 1
    Plug 'vim-python/python-syntax', { 'for': 'python' }

    " make all of my parentheses look like clown vomit. Turn on with yo(
    " see :h cterm-colors
    let g:rainbow_conf = {
        \ 'guifgs': ['Grey', 'LightBlue', 'LightGreen', 'LightCyan', 'LightMagenta', 'LightYellow', 'White'],
        \ 'ctermfgs': ['Grey', 'LightBlue', 'LightGreen', 'LightCyan', 'LightMagenta', 'LightYellow', 'White'],
        \ }
    Plug 'luochen1990/rainbow'
    nnoremap yo( :RainbowToggle<CR>

    " makes gc comment-uncomment lines
    Plug 'tpope/vim-commentary'

    " allow operations on the surround bits of text objects with the 's' prefix.
    " eg cs({ changes () to {}
    " Disable the weird <C-s> mapping to insert surround things in insert mode
    let g:surround_no_insert_mappings = 1
    Plug 'tpope/vim-surround'
    " make . repeat some compatible <Plug> commands,
    " and provide some infrastructure to do this myself in other places.
    Plug 'tpope/vim-repeat'

    " This is a dependency for some of the other textobject related plugins
    Plug 'kana/vim-textobj-user'

    " Access lines as text objects with 'l'
    Plug 'kana/vim-textobj-line'

    " textobjects for folds with az and iz
    Plug 'kana/vim-textobj-fold'

    " make ag a textobject for the entire document
    let g:textobj_entire_no_default_key_mappings=1
    Plug 'kana/vim-textobj-entire'

    xmap ag <Plug>(textobj-entire-a)
    omap ag <Plug>(textobj-entire-a)

    call plug#end()

endif

" }}}
