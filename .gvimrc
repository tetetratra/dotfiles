set background=dark

let g:trance_level = 0
set transparency=0
func! Trance()
  if g:trance_level == 0
    set transparency=20
    let g:trance_level = 1
  else
    set transparency=0
    let g:trance_level = 0
  endif
endfunc
noremap <D-u> :call Trance()<CR>

let g:bg_color = 0
highlight Normal guibg=#000000
autocmd BufEnter *
\ if g:bg_color == 0 |
\   highlight Normal guibg=#000000 |
\ elseif g:bg_color == 1 |
\   highlight Normal guibg=#000015 |
\ elseif g:bg_color == 2 |
\   highlight Normal guibg=#001500 |
\ elseif g:bg_color == 3 |
\   highlight Normal guibg=#150000 |
\ elseif g:bg_color == 4 |
\   highlight Normal guibg=#151500 |
\ elseif g:bg_color == 5 |
\   highlight Normal guibg=#150015 |
\ elseif g:bg_color == 6 |
\   highlight Normal guibg=#001515 |
\ elseif g:bg_color == 7 |
\   highlight Normal guibg=#151515 |
\ endif
func! BgColorChange()
  if g:bg_color == 7
    let g:bg_color = 0
  else
    let g:bg_color += 1
  endif
  :tabnew
  :bd
endfunc
noremap <D-y> :call BgColorChange()<CR>

set blur=0
set guifont=Monaco:h16

"右スクロールバーなし
set guioptions-=r
set guioptions-=R
"左スクロールバーなし
set guioptions-=l
set guioptions-=L
"下スクロールバーなし
set guioptions-=b
" タブの番号とフルパスを表示
set guitablabel=%N\ %f

" font size cahnge https://vi.stackexchange.com/questions/3093/how-can-i-change-the-font-size-in-gvim
function! FontSizePlus ()
  let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
  let l:gf_size_whole = l:gf_size_whole + 1
  let l:new_font_size = ':h'.l:gf_size_whole
  let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
endfunction
function! FontSizeMinus ()
  let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
  let l:gf_size_whole = l:gf_size_whole - 1
  let l:new_font_size = ':h'.l:gf_size_whole
  let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
endfunction
nmap <D--> :call FontSizeMinus()<CR>
nmap <D-+> :call FontSizePlus()<CR>
nmap <D-0> :set guifont=Monaco:h16<CR>
