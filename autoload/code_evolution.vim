function! code_evolution#show_timeline()
    let l:current_file = expand('%:p')
    let l:filetype = expand('%:e')
    let l:commit_history = git_integration#get_commit_history_for_current_file()
    let l:timeline = ""

    for l:commit in l:commit_history
        let l:timeline .= l:commit['date'] . ' | ' . l:commit['hash'] . ' | ' . l:commit['subject'] . '(' . l:commit['author'] . ')' . "\n"
    endfor

    enew
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal filetype=code_evolution
    setlocal noswapfile
    call setline(1, split(l:timeline, '\n'))
    setlocal nomodified
    setlocal nomodifiable
    let b:original_file = l:current_file
    let b:original_filetype = l:filetype
    nnoremap <buffer> <Enter> :call code_evolution#show_commit(split(getline('.'), ' \| ')[1], b:original_file, b:original_filetype)<CR>
endfunction

function! code_evolution#show_commit(commit_hash, original_file, filetype)
    let l:diff = s:get_cleaned_diff(a:commit_hash, a:original_file)

    setlocal splitright
    if exists("b:is_past_view")
        execute "wincmd l"
        enew
    else
        vnew
    endif

    let l:commit_info = system('git show -s --format="%ci | %s" ' . a:commit_hash)
    call setline(1, ["Commit: " . a:commit_hash . " (" . l:commit_info . ")", ""] + split(l:diff, '\n'))
    setlocal buftype=nofile
    setlocal bufhidden=wipe
    setlocal filetype=code_evolution
    execute 'setlocal filetype=' . a:filetype . '.code_evolution'
    setlocal noswapfile
    setlocal nomodified
    setlocal nomodifiable
    nnoremap <buffer> <silent> <C-o> :tabclose<CR>
    execute "wincmd p"
    let b:is_past_view = 1
endfunction

function! s:get_cleaned_diff(commit_hash, original_file)
    let l:git_root = s:git_root()[:-2] " Remove trailing newline
    let l:relative_path = substitute(a:original_file, l:git_root . '/', '', '')

    " Get the diff between the previous commit and the specified commit
    let l:diff_output = system('git diff -U9999 ' . a:commit_hash . '~1 ' . a:commit_hash . ' ' . l:relative_path)

    " Remove unnecessary lines from the diff output
    let l:cleaned_diff = join(filter(split(l:diff_output, '\n'), 'v:val !~# "^diff --git" && v:val !~# "^index " && v:val !~# "^--- " && v:val !~# "^+++ " && v:val !~# "^@@"'), "\n")

    return l:cleaned_diff
endfunction

function! s:git_root()
    return system('git rev-parse --show-toplevel')
endfunction
