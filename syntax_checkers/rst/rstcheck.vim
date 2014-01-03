"============================================================================
"File:        rstcheck.vim
"Description: Syntax checking for reStructuredText and embedded code blocks
"Authors:     Steven Myint <git@stevenmyint.com>
"
"============================================================================

" https://github.com/myint/rstcheck
"
" To install rstcheck:
"     $ pip install --upgrade rstcheck

if exists("g:loaded_syntastic_rst_rstcheck_checker")
    finish
endif
let g:loaded_syntastic_rst_rstcheck_checker=1

function! SyntaxCheckers_rst_rstcheck_GetLocList() dict
    let makeprg = self.makeprgBuild({})

    let errorformat =
        \ '%f:%l: (%tNFO/1) %m,'.
        \ '%f:%l: (%tARNING/2) %m,'.
        \ '%f:%l: (%tRROR/3) %m,'.
        \ '%f:%l: (%tEVERE/4) %m,'.
        \ '%-G%.%#'

    let loclist = SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat })

    for e in loclist
        if e['type'] ==? 'S'
            let e['type'] = 'E'
        elseif e['type'] ==? 'I'
            let e['type'] = 'W'
            let e['subtype'] = 'Style'
        endif
    endfor

    return loclist
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'rst',
    \ 'name': 'rstcheck'})