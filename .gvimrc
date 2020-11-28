let g:istrance = 1
set transparency=0
func! Trance()
  if g:istrance == 1
    set transparency=20
    let g:istrance = 0
  else
    set transparency=0
    let g:istrance = 1
  endif
endfunc
noremap <D-u> :<C-u>call Trance()<CR>

set blur=0
set guifont=SFMono-Regular:h20

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
nmap <D-0> :set guifont=SFMono-Regular:h16<CR>

