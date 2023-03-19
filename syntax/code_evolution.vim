 " タイムラインビューのハイライト定義
if &filetype !~# '\v^\w+\.code_evolution$'
    syntax match ceDate       /^\d\{4}-\d\{2}-\d\{2}/ nextgroup=ceSeparator
    syntax match ceSeparator  / \| / contained nextgroup=ceHash
    syntax match ceHash       /\v[a-f0-9]{7,}/
endif

" 過去コードビューのハイライト定義
syntax match ceAddedLine  /^+/
syntax match ceDeletedLine /^-/
syntax match ceCommitInfo /^Commit:.*/

" ハイライトスタイルの定義
highlight default link ceDate       Statement
highlight default link ceSeparator  Delimiter
highlight default link ceHash       Constant
highlight default link ceAddedLine  DiffAdd
highlight default link ceDeletedLine DiffDelete
highlight default link ceCommitInfo PreProc
