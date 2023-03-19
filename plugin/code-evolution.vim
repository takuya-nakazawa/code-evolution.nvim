command! ShowCurrentFileCommitHistory echo git_integration#get_commit_history_for_current_file()
command! ShowTimeline call code_evolution#show_timeline()

