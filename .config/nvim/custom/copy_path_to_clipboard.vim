function! ToRepoPath(fpath)
	return substitute(expand(a:fpath), $PWD . "/", "", "")
endfunc

function! CppToH(fpath)
	return substitute(expand(a:fpath), '.cpp', '.h', "")
endfunc

function! ToCppIncludePath(fpath)
	return '#include "' . ToRepoPath(substitute(CppToH(a:fpath), "src/", "", "")) . '"' 
endfunc

function! GetLineColumnSuffix()
	return ":" . line('.') . ":" . col('.')
endfunc

command! -nargs=0 CopyRepoPathWithLineCol let @+ = ToRepoPath(expand("%:f")) . GetLineColumnSuffix() . "\n"

command! -nargs=1 CopyPath let @+ = <q-args>
command! -nargs=1 CopyIncludePath let @+ = ToCppIncludePath(<q-args>) . "\n"
command! -nargs=1 CopyRepoPath let @+ = ToRepoPath(<q-args>) . "\n"
command! -nargs=0 CopyCurrentFilename let @+ = expand('%:t')

nmap <silent> <C-c> :execute "CopyIncludePath " . expand("%:f")<CR>
nmap <silent> <F24> :execute 'CopyRepoPath "' . expand("%:f") . '"'<CR>
"
"" F8 is bound to Ctrl+Shift+F

nmap <Space>s :execute "CopyPath " . 'cd $(dirname ' . expand("%:p") . ")"<CR>
nmap <Space>f :CopyCurrentFilename<CR>
nmap <Space>p :execute "CopyPath " . expand("%:p")<CR>
nmap <Space>d :execute "CopyPath " . expand("%:h")<CR>
