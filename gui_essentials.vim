"    ____         .__
"   / ___\ ___  __|__|  _____ _______   ____
"  / /_/  >\  \/ /|  | /     \\_  __ \_/ ___\
"  \___  /  \   / |  ||  Y Y  \|  | \/\  \___
" /_____/    \_/  |__||__|_|  /|__|    \___  >
"                           \/             \/
" FIGMENTIZE: gvimrc

" Essential basic setup for gvim

" Set some generic font for GVim, particularly we care about the font size.
" Only set it once because for some reason the screen messes itself up if you
" set it again.

" Haven't tested how this works for other frontends, or even if this font always
" exists.
if has("gui_gtk2") || has("gui_gtk3")
    command ResetFont set guifont=Monospace\ 12
else
    command ResetFont echo "not configured"
endif

if (!exists("g:did_set_font")) || !g:did_set_font
    ResetFont
    let g:did_set_font=1
endif

nnoremap g<C-l> <C-l>:redraw!<CR>

" binding to choose new font from a menu
nnoremap <Leader>f :set guifont=*<CR>

" Allow increasing/decreasing the font size
function! IncreaseFontSize() abort
    let &guifont = substitute(
     \ &guifont,
     \ '\d\+',
     \ '\=eval(submatch(0)+1)',
     \ '')
endfunction

function! DecreaseFontSize() abort
    let &guifont = substitute(
     \ &guifont,
     \ '\d\+',
     \ '\=max([1, eval(submatch(0)-1)])',
     \ '')
endfunction

" Mappings. These can be a bit janky, but basically do <Space>F+++--++++=
nmap <Leader>F <SID>(fresize)
nmap <script> <SID>(fresize)- :call DecreaseFontSize()<CR><SID>(fresize)
nmap <script> <SID>(fresize)+ :call IncreaseFontSize()<CR><SID>(fresize)
nmap <script> <SID>(fresize)= :ResetFont<CR><SID>(fresize)
nmap <script> <SID>(fresize) <Nop>

" Toggle extra GUI elements with <F7>. By default, make GVim looks like normal
" vim.
let g:goedel_gui_is_up = 1
function! ToggleGUI() abort
    if g:goedel_gui_is_up
        " same as default guioptions, but without tabs, scrollbars, menus or
        " toolbars.
        set guioptions=agitc
    else
        set guioptions&
    endif
    let g:goedel_gui_is_up = !g:goedel_gui_is_up
endfunction
call ToggleGUI()
nnoremap <F7> :call ToggleGUI()<CR>
inoremap <F7> <C-o>:call ToggleGUI()<CR>

" Toggle whether or not the cursor is blinking with <F8>. By default, don't do
" that, because it's annoying.
let g:goedel_cursor_is_blinking = 1
function! ToggleBlinking() abort
    if g:goedel_cursor_is_blinking
        " same as default options but turn off blinking
        set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,ve:ver35-Cursor-blinkon0,o:hor50-Cursor-blinkon0,i-ci:ver25-Cursor/lCursor-blinkon0,r-cr:hor20-Cursor/lCursor-blinkon0,sm:block-Cursor-blinkon0
    else
        set guicursor&
    endif
    let g:goedel_cursor_is_blinking = !g:goedel_cursor_is_blinking
endfunction
call ToggleBlinking()
nnoremap <F8> :call ToggleBlinking()<CR>
inoremap <F8> <C-o>:call ToggleBlinking()<CR>
