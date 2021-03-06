" Author: w0rp <devw0rp@gmail.com>
" Description: Error handling for flake8, etc.

let s:path_pattern = '[a-zA-Z]\?\\\?:\?[[:alnum:]/\.\-_]\+'

function! ale#handlers#python#HandlePEP8Format(buffer, lines) abort
    " Matches patterns line the following:
    "
    " Matches patterns line the following:
    "
    " stdin:6:6: E111 indentation is not a multiple of four
    " test.yml:35: [EANSIBLE0002] Trailing whitespace
    let l:pattern = '^' . s:path_pattern . ':\(\d\+\):\?\(\d\+\)\?: \[\?\(\([[:alpha:]]\)[[:alnum:]]\+\)\]\? \(.*\)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        let l:code = l:match[3]

        if (l:code ==# 'W291' || l:code ==# 'W293' || l:code ==# 'EANSIBLE002')
        \ && !g:ale_warn_about_trailing_whitespace
            " Skip warnings for trailing whitespace if the option is off.
            continue
        endif

        if l:code ==# 'I0011'
            " Skip 'Locally disabling' message
             continue
        endif

        call add(l:output, {
        \   'lnum': l:match[1] + 0,
        \   'col': l:match[2] + 0,
        \   'text': l:code . ': ' . l:match[5],
        \   'type': l:match[4] ==# 'E' ? 'E' : 'W',
        \})
    endfor

    return l:output
endfunction
