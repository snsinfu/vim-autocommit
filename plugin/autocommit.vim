" autocommit.vim - Auto-commit on file save.
" Maintainer: snsinfu <snsinfu@gmail.com>
" Source:     https://github.com/snsinfu/vim-autocommit
" Version:    0.1

if exists('g:loaded_autocommit')
  finish
endif
let g:loaded_autocommit = 1

function! s:config(var, default) abort
  if !exists(a:var)
    execute 'let' a:var '=' string(a:default)
  endif
endfunction

call s:config('g:autocommit_message_prefix', 'wip! ')
call s:config('g:autocommit_on_save', 1)

command! AutoCommit call autocommit#do_autocommit(bufnr(''))

augroup autocommit
  autocmd!
  if g:autocommit_on_save
    autocmd BufWritePost * AutoCommit
  endif
augroup END
