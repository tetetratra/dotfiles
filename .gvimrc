let g:trance_level = 0
let g:trance_level_up = 33
set transparency=0
func! Trance()
  if g:trance_level == 0
    set transparency=33
    let g:trance_level = 1
  elseif g:trance_level == 1
    set transparency=66
    let g:trance_level = 2
  elseif g:trance_level == 2
    set transparency=100
    let g:trance_level = 3
  elseif g:trance_level == 3
    set transparency=0
    let g:trance_level = 0
  endif
endfunc
noremap <D-u> :<C-u>call Trance()<CR>

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
