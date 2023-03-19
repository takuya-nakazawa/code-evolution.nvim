function! git_integration#get_commit_history_for_current_file()
    let l:current_file = expand('%:p')
    let l:git_log = system('git log --pretty=format:"%h|%s|%ad" --date=short ' . l:current_file)
    let l:commit_history = []

    for l:line in split(l:git_log, '\n')
        let l:commit = {}
        let l:commit_data = split(l:line, '|')
        let l:commit['hash'] = l:commit_data[0]
        let l:commit['subject'] = l:commit_data[1]
        let l:commit['date'] = l:commit_data[2]
        call add(l:commit_history, l:commit)
    endfor

    return l:commit_history
endfunction
