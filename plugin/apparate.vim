"==============================================================================
"File:        apparate.vim
"Description: Magically transport to and operate on a variety of text objects.
"Maintainer:  Pierre-Guy Douyon <pgdouyon@alum.mit.edu>
"Version:     1.0.0
"Last Change: 2014-12-09
"License:     MIT <../LICENSE>
"==============================================================================

if exists("g:loaded_apparate")
    finish
endif
let g:loaded_apparate = 1

let s:save_cpo = &cpoptions
set cpoptions&vim


" ======================================================================
" Plugin Code
" ======================================================================
function! s:ApparatePairs(inclusive, direction, delimiter)
    let save_pos = getpos(".")
    let direction = (a:direction ==# "n") ? "" : "b"
    let tr_set = (a:direction ==# "n") ? "({[<" : ")}]>"
    let delimiter = tr(a:delimiter, "bBra", tr_set)
    for _ in range(v:count1)
        call search('\V'.delimiter, 'W'.direction)
    endfor
    execute "normal! v".a:inclusive.delimiter
    call setpos("''", save_pos)
endfunction

function! s:ApparateSeparators(inclusive, separator)
    let save_pos = getpos(".")
    let on_first_sep_re = printf('\V\^\[^%s]\*\%%%dc%s', a:separator, col("."), a:separator)
    let on_last_sep_re = printf('\V\%%%dc%s\[^%s]\*\$', col("."), a:separator, a:separator)
    let inside_seps_re = printf('\V%s\.\*\%%%dc\.\*%s', a:separator, col("."), a:separator)

    let on_first_sep = (getline(".") =~# on_first_sep_re)
    let on_last_sep = (getline(".") =~# on_last_sep_re)
    let inside_seps = (getline(".") =~# inside_seps_re)
    if on_first_sep
        call search(".", 'W')
    elseif on_last_sep
        call search(".", 'bW')
    elseif !inside_seps
        return
    endif

    let inclusive_pat = (a:inclusive ==# "i") ? '\zs' : ''
    let end = searchpos('\V\.\ze'.a:separator, 'cW', line("."))
    let start = searchpos('\V'.a:separator.inclusive_pat, 'bW', line("."))
    call setpos("'[", [0, start[0], start[1], 0])
    call setpos("']", [0, end[0], end[1], 0])
    normal! `[v`]
    call setpos("''", save_pos)
endfunction

function! s:ApparateSeparatorsNL(inclusive, direction, separator)
    let save_pos = getpos(".")
    let direction = (a:direction ==# "n") ? "" : "b"
    for _ in range(v:count1)
        call search('\V'.a:separator, 'W'.direction, line("."))
    endfor
    call s:ApparateSeparators(a:inclusive, a:separator)
    call setpos("''", save_pos)
endfunction


" ======================================================================
" Plugin Mappings
" ======================================================================
for pair in ["b","B","r","a","(","{","[","<","t","'", "`", '"']
    execute printf("onoremap <silent> in%s :<C-U>call <SID>ApparatePairs('i','n','%s')<CR>", pair, pair)
    execute printf("onoremap <silent> il%s :<C-U>call <SID>ApparatePairs('i','l','%s')<CR>", pair, pair)
    execute printf("onoremap <silent> an%s :<C-U>call <SID>ApparatePairs('a','n','%s')<CR>", pair, pair)
    execute printf("onoremap <silent> al%s :<C-U>call <SID>ApparatePairs('a','l','%s')<CR>", pair, pair)
endfor

for sep in [",", ".", ";", ":", "+", "-", "~", "_", "*", "/", "&", "$"]
    execute printf("onoremap <silent> i%s :<C-U>call <SID>ApparateSeparators('i', '%s')<CR>", sep, sep)
    execute printf("onoremap <silent> a%s :<C-U>call <SID>ApparateSeparators('a', '%s')<CR>", sep, sep)
endfor

for sep in [",", ".", ";", ":", "+", "-", "~", "_", "*", "/", "&", "$"]
    execute printf("onoremap <silent> in%s :<C-U>call <SID>ApparateSeparatorsNL('i', 'n', '%s')<CR>", sep, sep)
    execute printf("onoremap <silent> il%s :<C-U>call <SID>ApparateSeparatorsNL('i', 'l', '%s')<CR>", sep, sep)
    execute printf("onoremap <silent> an%s :<C-U>call <SID>ApparateSeparatorsNL('a', 'n', '%s')<CR>", sep, sep)
    execute printf("onoremap <silent> al%s :<C-U>call <SID>ApparateSeparatorsNL('a', 'l', '%s')<CR>", sep, sep)
endfor

onoremap <silent> i\| :<C-U>call <SID>ApparateSeparators("i", "\|")<CR>
onoremap <silent> a\| :<C-U>call <SID>ApparateSeparators("a", "\|")<CR>
onoremap <silent> in\| :<C-U>call <SID>ApparateSeparatorsNL("i", "n", "\|")<CR>
onoremap <silent> an\| :<C-U>call <SID>ApparateSeparatorsNL("a", "n", "\|")<CR>
onoremap <silent> il\| :<C-U>call <SID>ApparateSeparatorsNL("i", "l", "\|")<CR>
onoremap <silent> al\| :<C-U>call <SID>ApparateSeparatorsNL("a", "l", "\|")<CR>

onoremap <silent> i\ :<C-U>call <SID>ApparateSeparators('i', '\\')<CR>
onoremap <silent> a\ :<C-U>call <SID>ApparateSeparators('a', '\\')<CR>
onoremap <silent> in\ :<C-U>call <SID>ApparateSeparatorsNL('i', 'n', '\\')<CR>
onoremap <silent> an\ :<C-U>call <SID>ApparateSeparatorsNL('a', 'n', '\\')<CR>
onoremap <silent> il\ :<C-U>call <SID>ApparateSeparatorsNL('i', 'l', '\\')<CR>
onoremap <silent> al\ :<C-U>call <SID>ApparateSeparatorsNL('a', 'l', '\\')<CR>


let &cpoptions = s:save_cpo
unlet s:save_cpo
