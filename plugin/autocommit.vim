" autocommit.vim - Git auto-commit plugin.
" Maintainer: snsinfu <snsinfu@gmail.com>
" Source:     https://github.com/snsinfu/vim-autocommit
" Version:    0.2

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

command! AutoCommit call autocommit#do_autocommit(bufnr(''))

augroup autocommit
  autocmd!
  autocmd BufLeave * AutoCommit
  autocmd BufWinLeave * AutoCommit
augroup END
