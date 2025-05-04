" ────────────────────────────────────────────────────────────────
" 1) ensure syntax & conceal support is on
" ────────────────────────────────────────────────────────────────
syntax on
set conceallevel=2          " hide concealed text by default
set concealcursor=n         " disable conceal on the cursor line in Normal

" ────────────────────────────────────────────────────────────────
" 2) your jump mappings (unchanged)
" ────────────────────────────────────────────────────────────────
let g:orglinks_jumpstack = []

function! OrgLinksFollowLink()
  let l:line = getline('.')
  if l:line =~ '\[\[.*\]\]'
    let l:link = matchstr(l:line, '\[\[\zs.*\ze\]\]')
    let l:full = fnamemodify(expand('%:p:h').'/'.l:link, ':p')
    if isdirectory(l:full)
      let l:full .= '/index'
    endif
    call add(g:orglinks_jumpstack, expand('%:p'))
    if &modified
      " Option 1: Force navigation (may lose changes)
      write
      execute 'edit!' fnameescape(l:full)
    else
      execute 'edit' fnameescape(l:full)
    endif
  endif
endfunction

function! OrgLinksGoBack()
  if !empty(g:orglinks_jumpstack)
    " Use the bang version of edit to override unsaved changes warning
    " or save the file before navigating away
    if &modified
      " Option 1: Force navigation (may lose changes)
      write
      execute 'edit!' remove(g:orglinks_jumpstack, -1)

      " Option 2: Ask user what to do (uncomment this block if preferred)
      " let choice = confirm("Save changes before going back?", "&Yes\n&No\n&Cancel", 1)
      " if choice == 1
      "   write
      "   execute 'edit' remove(g:orglinks_jumpstack, -1)
      " elseif choice == 2
      "   execute 'edit!' remove(g:orglinks_jumpstack, -1)
      " else
      "   " User canceled
      "   return
      " endif
    else
      " No unsaved changes, proceed normally
      execute 'edit' remove(g:orglinks_jumpstack, -1)
    endif
  endif
endfunction

augroup OrgLinkHover
  autocmd!
  autocmd CursorMoved,CursorMovedI * call ToggleOrgLinkConceal()
augroup END

function! ToggleOrgLinkConceal() abort
  " Skip for directories or non-file buffers
  if expand('%:e') !=# '' || !filereadable(expand('%')) | return | endif

  " First, check if highlight groups exist before clearing
  if hlexists('OrgLinksBracketsCurrent')
    syntax clear OrgLinksBracketsCurrent
  endif
  if hlexists('OrgLinksLinkCurrent')
    syntax clear OrgLinksLinkCurrent
  endif

  " Always set conceallevel=2 to hide brackets
  setlocal conceallevel=2

  let line = getline('.')
  let col0 = col('.') - 1
  let lnum = line('.')

  let start_pos = 0
  while 1
    let start = match(line, '\[\[', start_pos)
    if start == -1 | break | endif
"
    let end = match(line, '\]\]', start)
    if end == -1 | break | endif
    " Include the closing brackets
    let end += 2

    " Check if cursor is within this link
    if col0 >= start && col0 < end
      " Create a syntax region just for this specific link without concealing
      execute 'syntax region OrgLinksLinkCurrent matchgroup=OrgLinksBracketsCurrent start=/\%' . lnum . 'l\%' . (start+1) . 'c\[\[/ end=/\%' . lnum . 'l\%' . end . 'c/'
      break
    endif

    let start_pos = end
  endwhile
endfunction

" ────────────────────────────────────────────────────────────────
" 3) file-without-extension setup: mappings + syntax rules
" ────────────────────────────────────────────────────────────────
augroup NoExtLinksLinks
  autocmd!
  autocmd BufReadPost,BufNewFile * if expand('%:e') ==# '' && !isdirectory(expand('%')) |
        \ call s:SetupNoExtLinks() |
        \ endif
augroup END

function! s:SetupNoExtLinks() abort
  syntax region OrgLinksLinkCurrent matchgroup=OrgLinksBracketsCurrent start=+\[\[+ end=+\]\]+ concealends containedin=ALL
  " jump mappings
  "nnoremap <buffer> <CR> :call OrgLinksFollowLink()<CR>
  nnoremap <silent><buffer> <CR> <Cmd>call OrgLinksFollowLink()<CR>
  "nnoremap <buffer> <BS> :call OrgLinksGoBack()<CR>
  nnoremap <silent><buffer> <BS> <Cmd>call OrgLinksGoBack()<CR>


  " Base syntax rule with concealends for all links
  syntax region OrgLinksLink matchgroup=OrgLinksBrackets start='\[\[' end='\]\]' concealends containedin=ALL

  highlight OrgLinksBrackets gui=underline cterm=underline
  highlight OrgLinksLink gui=underline cterm=underline
  highlight OrgLinksBracketsCurrent gui=underline cterm=underline
  highlight OrgLinksLinkCurrent gui=underline cterm=underline
endfunction
