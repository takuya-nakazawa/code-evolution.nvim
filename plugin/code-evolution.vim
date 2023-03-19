command! ShowCurrentFileCommitHistory echo git_integration#get_commit_history_for_current_file()
command! ShowTimeline call code_evolution#show_timeline()

augroup code_evolution_syntax
    autocmd!
    autocmd FileType code_evolution runtime! syntax/code_evolution.vim
augroup END
