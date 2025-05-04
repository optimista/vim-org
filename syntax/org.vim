" Custom headings syntax for all buffers
" This file should be placed in ~/.vim/syntax/ or similar location
" " full-buffer parse on every redraw
syntax sync fromstart
" or limit backward scan to 500 lines
syntax sync maxlines=500

" Only load this syntax file when no other was loaded
if exists("b:current_syntax")
  finish
endif

" Colors from onehalflight
let s:blue = { "gui": "#0184bc", "cterm": "31" }
let s:cyan = { "gui": "#0997b3", "cterm": "31" }
let s:red = { "gui": "#e45649", "cterm": "167" }
let s:comment_fg = { "gui": "#a0a1a7", "cterm": "247" }
let s:purple = { "gui": "#a626a4", "cterm": "127" }  " For surrounded title
let s:yellow      = { "gui": "#c18401", "cterm": "136" }
let s:green_dark = { "gui": "#40813F", "cterm": "22" }
let s:green       = { "gui": "#50a14f", "cterm": "71" }

" Create lighter versions of colors
let s:lighter_cyan = { "gui": "#4fb3c9", "cterm": "74" }
let s:lightest_cyan = { "gui": "#96D2E6", "cterm": "153" }
let s:lighter_red = { "gui": "#ea7c72", "cterm": "173" }
let s:lightest_red = { "gui": "#f0a39b", "cterm": "174" }

" Define syntax matches for our heading patterns

" Normal primary title (no border)
syntax match customHeading1NoBorder /^= .\+ =$/ 
syntax match customDiffHeading /^% .\+$/ 

syntax match customHeadingTitle /^=\{5,}\n= .\+ =\n=\{5,}$/ 
syntax match customDiffHeadingTitle /^=\{5,}\n% .\+ %\n=\{5,}$/ 

" Secondary title
syntax match customHeading2 /^== .\+ ==$/
syntax match customDiffHeading2 /^%% .\+$/

" Tertiary title
syntax match customHeading3 /^=== .\+ ===$/

" Markdown-style headings - match just the # at the start
syntax match customHeadingHash1 /^#\ze .\+$/
syntax match customHeadingHash2 /^##\ze .\+$/
syntax match customHeadingHash3 /^###\ze .\+$/

" Secondary text (bullet points)
"syntax match customSecondaryText /^- .\+$/

" Define highlighting for our custom syntax groups
function! s:hi_custom_headings()
  if g:colors_name == "onehalflight"
    " Create highlight groups using our color palette
    " Title 1 without border - blue, no bold
    exec "hi customHeading1NoBorder guifg=" . s:cyan.gui . " ctermfg=" . s:cyan.cterm . " gui=bold cterm=bold"
    exec "hi customDiffHeading guifg=" . s:green.gui . " ctermfg=" . s:green.cterm . " gui=bold cterm=bold"
    
    " Title 1 with border - purple + bold (supertitle)
    "exec "hi customHeadingBorderStart guifg=" . s:purple.gui . " ctermfg=" . s:purple.cterm . " gui=bold cterm=bold"
    "exec "hi customHeadingBorderEnd guifg=" . s:purple.gui . " ctermfg=" . s:purple.cterm . " gui=bold cterm=bold"
    exec "hi! customHeadingTitle guifg=" . s:blue.gui . " ctermfg=" . s:blue.cterm . " gui=bold cterm=bold"
    exec "hi! customDiffHeadingTitle guifg=" . s:green_dark.gui . " ctermfg=" . s:green_dark.cterm . " gui=bold cterm=bold"
    
    " Title 2 - cyan, no bold
    exec "hi customHeading2 guifg=" . s:cyan.gui . " ctermfg=" . s:cyan.cterm . " gui=NONE cterm=NONE"
    exec "hi customDiffHeading2 guifg=" . s:green.gui . " ctermfg=" . s:green.cterm . " gui=NONE cterm=NONE"
    
    " Title 3 - lighter cyan + no bold
    exec "hi customHeading3 guifg=" . s:lighter_cyan.gui . " ctermfg=" . s:lighter_cyan.cterm . " gui=NONE cterm=NONE"
    
    " Subtitles - only color the # symbols
    exec "hi customHeadingHash1 guifg=" . s:red.gui . " ctermfg=" . s:red.cterm . " gui=NONE cterm=NONE"
    exec "hi customHeadingHash2 guifg=" . s:lighter_red.gui . " ctermfg=" . s:lighter_red.cterm . " gui=NONE cterm=NONE"
    exec "hi customHeadingHash3 guifg=" . s:lightest_red.gui . " ctermfg=" . s:lightest_red.cterm . " gui=NONE cterm=NONE"
    
    " Secondary text using comment color
    "exec "hi customSecondaryText guifg=" . s:comment_fg.gui . " ctermfg=" . s:comment_fg.cterm . " gui=NONE cterm=NONE"
  endif
endfunction

" Run highlighting when this file is sourced
call s:hi_custom_headings()

" Set current_syntax to prevent loading this file twice
let b:current_syntax = "custom_headings"

" and do it once now if you’ve already loaded your colorscheme:
exec "hi Folded guifg=#8c8e94 ctermfg=241 gui=italic cterm=italic"

" Create an autocommand to apply our highlighting whenever the colorscheme changes
augroup CustomHeadingsHighlight
  autocmd!
  autocmd ColorScheme * call s:hi_custom_headings()
augroup END
