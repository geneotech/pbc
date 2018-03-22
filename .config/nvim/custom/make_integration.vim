let $LASTERR_DIR = '/tmp'

let g:last_error_path = $LASTERR_DIR . '/last_error.txt'
let g:last_error_path_color = $LASTERR_DIR . '/last_error_color.txt'
let g:run_result_path = $LASTERR_DIR . '/run_result.txt'
let g:bt_path = $LASTERR_DIR . '/bt.txt'

function! OnBuildEvent(job_id, data, event) dict
	if filereadable(g:last_error_path)
		execute "lfile " . g:last_error_path
		normal zz
	elseif filereadable(g:bt_path)
		execute "lfile " . g:bt_path
	elseif filereadable(g:run_result_path)
		"lfile g:run_result_path
		let fff = readfile(g:run_result_path)

		if len(fff) > 0 
			echomsg fff[0]
		endif
	else
		echomsg "Build successful."
	endif
endfunction

function! SucklessMake(targetname)
	wa

	let runscript = expand("%:h") . "/run.sh"

    let callbacks = {
    \ 'on_exit': function('OnBuildEvent')
    \ }

	let jobcmd = "zsh -c '. ~/cfg/shell/vim_builders.sh; export SHELL=/bin/zsh; vim_target " . a:targetname . "'"

	if filereadable(runscript)
		let jobcmd = "zsh -c 'cd " . expand("%:h") . "; . " . runscript . "'"
	endif

	"echomsg jobcmd
    let job1 = jobstart(jobcmd, callbacks)
endfunction

function! MakeCurrentFile()
	let g:last_make_path = ToRepoPath(expand("%:f")) . ".o"
	call SucklessMake(g:last_make_path)
endfunction

function! MakeLastFile()
	if exists('g:last_make_path')
		call SucklessMake(g:last_make_path)
	else
		echomsg "First build something with Shift+F7."
	endif
endfunction

" Build bindings

" F19 = S+F7
nnoremap <silent> <F19> :call MakeCurrentFile()<CR>
nnoremap <silent> <F6> :call MakeLastFile()<CR>
nnoremap <silent> <F7> :call SucklessMake("all")<CR>
nnoremap <silent> <F5> :call SucklessMake("run")<CR>

inoremap <silent> <F19> <ESC><F19>
inoremap <silent> <F6> <ESC><F6>
inoremap <silent> <F5> <ESC><F5>
inoremap <silent> <F7> <ESC><F7>

function! OpenLastErrors()
	let opencmd = "tabnew term://bash -c 'cat " . g:last_error_path_color . "; bash'"
	echomsg opencmd
	execute opencmd
endfunction

nmap <Space>e :call OpenLastErrors()<CR>
