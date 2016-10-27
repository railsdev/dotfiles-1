set nocompatible

set runtimepath+=~/.vim/bundle/dein.vim

call dein#begin('~/.vim/bundle')
call dein#local('~/.vim/bundle')
call dein#end()

set nobomb
set exrc
set secure
set hidden
set ignorecase
set smartcase
set infercase
set linebreak
set tabstop=4
set shiftwidth=4
set encoding=utf-8
set titlelen=0
set titlestring=[%t]%m
set whichwrap+=[,],<,>
set wildmode=longest,list:longest,full
set wildignore+=*.o,*.a,a.out
set sessionoptions-=options

if len($DISPLAY)
    set clipboard+=unnamed
endif

filetype indent plugin on
syntax on

augroup vimrc
    autocmd!
augroup END

colorscheme elrond

if executable('rg')
	set grepprg=rg\ --vimgrep
elseif executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor\ --ignore-case\ --column
    set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

function! s:StripTrailingWhitespace()
    if !&binary && &filetype != 'diff'
        normal mz
        normal Hmy
        %s/\s+$//e
        normal 'yz<CR>
        normal `z
    endif
endfunction

command! -bar StripTrailingWhitespace silent call <SID>StripTrailingWhitespace()

if &term =~ "screen"
    map  <silent> [1;5D <C-Left>
    map  <silent> [1;5C <C-Right>
    lmap <silent> [1;5D <C-Left>
    lmap <silent> [1;5C <C-Right>
    imap <silent> [1;5D <C-Left>
    imap <silent> [1;5C <C-Right>

    set t_ts=k
    set t_fs=\
    set t_Co=16
endif

if $TERM =~ "xterm-256color" || $TERM =~ "screen-256color" || $TERM =~ "xterm-termite" || $TERM =~ "gnome-256color" || $COLORTERM =~ "gnome-terminal"
    set t_Co=256
    set t_AB=[48;5;%dm
    set t_AF=[38;5;%dm
    set t_ZH=[3m
    set t_ZR=[23m
else
    if $TERM =~ "st-256color"
        set t_Co=256
    endif
endif

command! -nargs=0 -bang Q q<bang>
command! -nargs=0 -bang Wq wq<bang>

vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap < <gv
vnoremap > >gv

nnoremap H :bprevious<CR>
nnoremap L :bnext<CR>

map <C-t> <C-]>
map <C-p> :pop<cr>
map __ ZZ

" Jump to the last edited position in the file being loaded (if available)
autocmd vimrc BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\		execute "normal g'\"" |
			\ endif

" Readjust split-windows when Vim is resized
autocmd vimrc VimResized * :wincmd =

" Per-filetype settings
autocmd vimrc FileType mkdc,markdown setlocal expandtab tabstop=2 shiftwidth=2
autocmd vimrc FileType yaml setlocal tabstop=2 shiftwidth=2 expandtab
autocmd vimrc FileType objc setlocal expandtab cinoptions+=(0
autocmd vimrc FileType cpp setlocal expandtab cinoptions+=(0
autocmd vimrc FileType lua setlocal expandtab tabstop=3 shiftwidth=3
autocmd vimrc FileType c setlocal expandtab cinoptions+=(0
autocmd vimrc FileType d setlocal expandtab cinoptions+=(0

autocmd vimrc FileType dirvish call fugitive#detect(@%)
autocmd vimrc FileType dirvish keeppatterns g@\v/\.[^\/]+/?$@d

autocmd vimrc FileType help wincmd L
autocmd vimrc FileType git wincmd L | wincmd x

" dwm-like window movements
if has('nvim')
    nnoremap <silent> <BS>  <C-w>h
    nnoremap <silent> <NL>  <C-w>j
else
    nnoremap <silent> <C-h> <C-w>h
    nnoremap <silent> <C-j> <C-w>j
endif
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Manually re-format a paragraph of text
nnoremap <silent> Q gwip

" For coherency with C/D
cmap Y y$

" Forgot root?
if executable('doas')
    cmap w!! w !doas tee % > /dev/null
elseif executable('sudo')
    cmap w!! w !sudo tee % > /dev/null
endif

" Works with the default Vim Markdown support files
let g:markdown_fenced_languages = ['html', 'c', 'lua', 'bash=sh']

let g:email = 'aperez@igalia.com'
let g:user  = 'Adrian Perez'

" Plugin: racer
if executable('racer')
	let g:racer_cmd = 'racer'
endif

" Plugin: fzf
let g:fzf_buffers_jump = 0
nnoremap <silent> <Leader>f :<C-u>Files<cr>
nnoremap <silent> <Leader>F :<C-u>GitFiles<cr>
nnoremap <silent> <Leader>m :<C-u>History<cr>
nnoremap <silent> <Leader>b :<C-u>Buffers<cr>
nnoremap <silent> <Leader><F1> :<C-u>Helptags<cr>
nmap <C-A-p> <leader>f
nmap <C-A-m> <leader>m
nmap <C-A-b> <leader>b

if exists('#Lift')
    " Plugin: Lift
    inoremap <expr> <Tab>  lift#trigger_completion()
    inoremap <expr> <Esc>  pumvisible() ? "\<C-e>" : "\<Esc>"
    inoremap <expr> <CR>   pumvisible() ? "\<C-y>" : "\<CR>"
    inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
    inoremap <expr> <Up>   pumvisible() ? "\<C-p>" : "\<Up>"
    inoremap <expr> <C-d>  pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
    inoremap <expr> <C-u>  pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
elseif get(g:, 'loaded_completor_plugin')
    " Plugin: completor
    let g:completor_python_binary = '/usr/bin/python3'
    let g:completor_racer_binary = '/usr/bin/racer'
    let g:completor_clang_binary = '/usr/bin/clang'
    let g:completor_node_binary = '/usr/bin/node'
    let g:completor_disable_ultisnips = 1

    function! s:completor_tab(direction, or_keys)
        if pumvisible()
            if a:direction < 0
                return "\<C-p>"
            else
                return "\<C-n>"
            endif
        else
            return a:or_keys
        endif
    endfunction
    inoremap <expr> <Tab>   <SID>completor_tab(1, "\<Tab>")
    inoremap <expr> <S-Tab> <SID>completor_tab(-1, "\<S-Tab>")
endif

" Plugin: insearch + insearch-fuzzy
map <Space>  <Plug>(incsearch-forward)
map /        <Plug>(incsearch-forward)
map ?        <Plug>(incsearch-backward)
map g/       <Plug>(incsearch-stay)
map z<Space> <Plug>(incsearch-fuzzyspell-/)
map z/       <Plug>(incsearch-fuzzyspell-/)
map z?       <Plug>(incsearch-fuzzyspell-?)
map zg/      <Plug>(incsearch-fuzzyspell-stay)

highlight Flashy term=reverse cterm=reverse

" Plugin: expand-region
map <CR>        <Plug>(expand_region_expand)
map <Backspace> <Plug>(expand_region_shrink)
