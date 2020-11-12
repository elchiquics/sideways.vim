if exists("g:loaded_sideways") || &cp
  finish
endif

let g:loaded_sideways = '0.4.0' " version number
let s:keepcpo = &cpo
set cpo&vim

function! s:WithOverrides(definition, overrides)
  return extend(copy(a:definition), a:overrides)
endfunction

let s:html_like_definitions = {
      \   'tag_attributes': {
      \     'start':                   '<\k\+\_s\+',
      \     'end':                     '\s*/\?>',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['"''', '"'''],
      \   },
      \   'double_quoted_class': {
      \     'skip_syntax':             [],
      \     'start':                   '\<class="',
      \     'end':                     '"',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['', ''],
      \   },
      \   'single_quoted_class': {
      \     'skip_syntax':             [],
      \     'start':                   '\<class=''',
      \     'end':                     "'",
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['', ''],
      \   },
      \ }

let g:sideways_definitions =
      \ [
      \   {
      \     'start':                '\_^\s*',
      \     'end':                  '\s*=',
      \     'delimiter':            ',\s*',
      \     'single_line':          1,
      \     'zero_width_start':     1,
      \     'required_end_pattern': 1,
      \     'brackets':             ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'start':                '=\s*',
      \     'end':                  '$',
      \     'delimiter':            ',\s*',
      \     'single_line':          1,
      \     'required_end_pattern': 1,
      \     'brackets':             ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'start':     '(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'start':     '\[\_s*',
      \     'end':       '\]',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'start':     '{\_s*',
      \     'end':       '}',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{''"', ')]}''"'],
      \   },
      \ ]

autocmd FileType ruby
      \ if !exists('b:sideways_skip_syntax') |
      \   let b:sideways_skip_syntax = [
      \     '^rubyString$',
      \     '^rubySymbol$',
      \     '^rubyComment$',
      \     '^rubyInterpolation$',
      \   ] |
      \ endif
autocmd FileType ruby let b:sideways_definitions = [
      \   {
      \     'start':       '|\s*',
      \     'end':         '\s*|',
      \     'single_line': 1,
      \     'delimiter':   ',\s*',
      \     'brackets':    ['([{''"', ')]}''"'],
      \   },
      \   {
      \     'start':       '\k\{1,}[?!]\= \ze\s*[^=,*/%<>+-]',
      \     'end':         '\s*\%(\<do\>\|#\)',
      \     'delimiter':   ',\s*',
      \     'brackets':    ['([{''"', ')]}''"'],
      \   },
      \ ]

autocmd FileType python let b:sideways_definitions = [
      \   {
      \     'start':     '^\%(from .*\)\=import ',
      \     'end':       '$',
      \     'delimiter': ',\s*',
      \     'brackets':  ['', ''],
      \   },
      \ ]

autocmd FileType coffee let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['coffeeString', 'coffeeComment'],
      \     'start':       '\k\{1,} ',
      \     'end':         '\%(,\s*[-=]>\|\s*#\|$\)',
      \     'delimiter':   ',\s*',
      \     'brackets':    ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType haml,slim let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['rubyString'],
      \     'start':       '\k\{1,} ',
      \     'end':         '\s*\%(\<do\>\|#\|$\)',
      \     'delimiter':   ',\s*',
      \     'brackets':    ['([''"', ')]''"'],
      \   },
      \   {
      \     'start':       '^[^.]*\.',
      \     'end':         '\%(\k\|\.\)\@!',
      \     'single_line': 1,
      \     'delimiter':   '\.',
      \     'brackets':    ['', ''],
      \   },
      \ ]

autocmd FileType html let b:sideways_definitions = [
      \   s:html_like_definitions.tag_attributes,
      \   s:html_like_definitions.double_quoted_class,
      \   s:html_like_definitions.single_quoted_class,
      \ ]

autocmd FileType eruby let b:sideways_definitions = [
      \   {
      \     'start':     '<%=\=\s*\%(\k\|\.\|::\)*\k\{1,} ',
      \     'end':       '\s*%>',
      \     'delimiter': ',\s*',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \   s:WithOverrides(s:html_like_definitions.tag_attributes,      { 'brackets': ['"''<', '"''>'] }),
      \   s:WithOverrides(s:html_like_definitions.double_quoted_class, { 'brackets': ['<', '>'] }),
      \   s:WithOverrides(s:html_like_definitions.single_quoted_class, { 'brackets': ['<', '>'] }),
      \ ]

autocmd FileType handlebars,html.handlebars let b:sideways_definitions = [
      \   {
      \     'start':                   '{{#\=\%(\k\|-\|/\)\+\s*',
      \     'end':                     '\_s*}}',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['(''"', ')''"'],
      \   },
      \   s:WithOverrides(s:html_like_definitions.tag_attributes,      { 'brackets': ['"''{', '"''}'] }),
      \   s:WithOverrides(s:html_like_definitions.double_quoted_class, { 'brackets': ['{', '}'] }),
      \   s:WithOverrides(s:html_like_definitions.single_quoted_class, { 'brackets': ['{', '}'] }),
      \ ]

autocmd FileType javascript.jsx,javascriptreact,typescript.tsx,typescriptreact let b:sideways_definitions = [
      \   s:WithOverrides(s:html_like_definitions.tag_attributes,      { 'brackets': ['"''{', '"''}'] }),
      \   {
      \     'skip_syntax':             [],
      \     'start':                   '\<className="',
      \     'end':                     '"',
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['{', '}'],
      \   },
      \   {
      \     'skip_syntax':             [],
      \     'start':                   '\<className=''',
      \     'end':                     "'",
      \     'delimited_by_whitespace': 1,
      \     'brackets':                ['{', '}'],
      \   },
      \ ]

autocmd FileType rust
      \ if !exists('b:sideways_skip_syntax') |
      \   let b:sideways_skip_syntax = [
      \     'String',
      \     'Comment',
      \     'rustCharacter',
      \   ] |
      \ endif
autocmd FileType rust let b:sideways_definitions = [
      \   {
      \     'start':       '|\s*',
      \     'end':         '\s*|',
      \     'delimiter':   ',\s*',
      \     'single_line': 1,
      \     'brackets':    ['<([', '>)]'],
      \   },
      \   {
      \     'start':     '\%(struct\|enum\) \k\+\%(<.\{-}>\)\=\s*{\_s*',
      \     'end':       '}',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([<', ')]>'],
      \   },
      \   {
      \     'start':     '\%(struct\|enum\) \k\+\%(<.\{-}>\)\=\s*(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([<', ')]>'],
      \   },
      \   {
      \     'start':     '\k\s*{\_s*',
      \     'end':       '}',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{''"|', ')]}''"|'],
      \   },
      \   {
      \     'start':     'type \k\+\s*=.*(',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([<', ')]>'],
      \   },
      \   {
      \     'start':     'fn \k\+\%(<.\{-}>\)\=(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([<', ')]>'],
      \   },
      \   {
      \     'start':     '(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{"|', ')]}"|'],
      \   },
      \   {
      \     'start':     '\[\_s*',
      \     'end':       '\]',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{"', ')]}"'],
      \   },
      \   {
      \     'start':     '\<\k\+<',
      \     'end':       '>',
      \     'delimiter': ',\s*',
      \     'brackets':  ['<([', '>)]'],
      \     'single_line': 1,
      \   },
      \   {
      \     'start':     '\k\+:\s*',
      \     'end':       '[,>]',
      \     'delimiter': '\s*+\s*',
      \     'brackets':  ['', ''],
      \     'single_line': 1,
      \   },
      \   {
      \     'start':     '::<',
      \     'end':       '>',
      \     'delimiter': ',\s*',
      \     'brackets':  ['<([', '>)]'],
      \     'single_line': 1,
      \   },
      \   {
      \     'start':     ')\_s*->\_s*',
      \     'end':       '\_s*{',
      \     'delimiter': 'NO_DELIMITER_SIDEWAYS_CARES_ABOUT',
      \     'brackets':  ['<([', '>)]'],
      \   },
      \ ]

autocmd FileType go let b:sideways_definitions = [
      \   {
      \     'start':     '{\_s*',
      \     'end':       '\_s*}',
      \     'delimiter': ',\s*',
      \     'brackets':  ['([''"', ')]''"'],
      \   },
      \ ]

autocmd FileType cpp let b:sideways_definitions = [
      \   {
      \     'start':     '(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \   {
      \     'start':     '\[\_s*',
      \     'end':       '\]',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \   {
      \     'start':     '{\_s*',
      \     'end':       '}',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \   {
      \     'start':     'template \zs<\ze\|\S\zs<\ze\S',
      \     'end':       '>',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \ ]

autocmd FileType java let b:sideways_definitions = [
      \   {
      \     'start':     '(\_s*',
      \     'end':       ')',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \   {
      \     'start':     '\S\zs<\ze\S',
      \     'end':       '>',
      \     'delimiter': ',\_s*',
      \     'brackets':  ['([{<''"', ')]}>''"'],
      \   },
      \ ]

autocmd FileType css,scss,less let b:sideways_definitions = [
      \   {
      \     'start':     '\k:\s*',
      \     'end':       ';',
      \     'delimiter': '\s',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \   {
      \     'start':     '{\_s*',
      \     'end':       ';\=\_s*}',
      \     'delimiter': ';\_s*',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \ ]

autocmd FileType cucumber let b:sideways_definitions = [
      \   {
      \     'start':     '^\s*|\s*',
      \     'end':       '\s*|$',
      \     'delimiter': '\s*|\s*',
      \     'brackets':  ['(''"', ')''"'],
      \   },
      \ ]

autocmd FileType sh let b:sideways_definitions = [
      \   {
      \     'skip_syntax': ['shDoubleQuote', 'shSingleQuote', 'shComment'],
      \     'start':       '\%(^\|[|(`]\)\s*\k\{1,} \ze\s*[^=]',
      \     'end':         '\s*\%(|\|\_$\)',
      \     'brackets':    ['([{''"', ')]}''"'],
      \     'single_line': 1,
      \     'delimited_by_whitespace': 1,
      \   },
      \ ]

autocmd FileType ocaml let b:sideways_definitions = [
      \   {
      \     'start':     '\[|\=\_s*',
      \     'end':       '|\=\]',
      \     'delimiter': ';\_s*',
      \     'brackets':  ['(["', ')]"'],
      \   },
      \ ]

if !exists('g:sideways_search_timeout')
  let g:sideways_search_timeout = 0
endif

if !exists('g:sideways_skip_strings_and_comments')
  let g:sideways_skip_strings_and_comments = 1
endif

if !exists('g:sideways_add_item_cursor_restore')
  let g:sideways_add_item_cursor_restore = 0
endif

command! SidewaysLeft  call sideways#MoveLeft()  | silent! call repeat#set("\<Plug>SidewaysLeft")
command! SidewaysRight call sideways#MoveRight() | silent! call repeat#set("\<Plug>SidewaysRight")

command! SidewaysJumpLeft  call sideways#JumpLeft()
command! SidewaysJumpRight call sideways#JumpRight()

nnoremap <silent> <Plug>SidewaysLeft  :<c-u>SidewaysLeft<cr>
nnoremap <silent> <Plug>SidewaysRight :<c-u>SidewaysRight<cr>

onoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
xnoremap <Plug>SidewaysArgumentTextobjA :<c-u>call sideways#textobj#Argument('a')<cr>
onoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>
xnoremap <Plug>SidewaysArgumentTextobjI :<c-u>call sideways#textobj#Argument('i')<cr>

nnoremap <Plug>SidewaysArgumentInsertBefore :<c-u>call sideways#new_item#Add('i')<cr>
nnoremap <Plug>SidewaysArgumentAppendAfter  :<c-u>call sideways#new_item#Add('a')<cr>
nnoremap <Plug>SidewaysArgumentInsertFirst  :<c-u>call sideways#new_item#AddFirst()<cr>
nnoremap <Plug>SidewaysArgumentAppendLast   :<c-u>call sideways#new_item#AddLast()<cr>

let &cpo = s:keepcpo
unlet s:keepcpo
