" Commits the file (only the file) opened in specified buffer with an auto-
" generated message. Nothing is done if the file is not changed.
"
" Args:
"   bufnr - Buffer number.
"
" VimConfig:
"   b:autocommit_disabled
"   g:autocommit_message_prefix
"
" GitConfig:
"   vim_autocommit.enabled
"   vim_autocommit.branch_prefix
"
function! autocommit#do_autocommit(bufnr) abort
  let path = resolve(expand('#' . a:bufnr . ':p'))

  if getbufvar(a:bufnr, 'autocommit_disabled', 0)
    return
  endif

  let gittop = autocommit#git#query_topdir(path)
  if len(gittop) == 0
    " Not under git working tree.
    return
  endif

  if !autocommit#utils#starts_with(path, gittop)
    " Unexpected.
    return
  endif

  let enabled = autocommit#git#get_config(path, "vim_autocommit.enabled")
  if enabled != 1
    " Not enabled in this repository.
    return
  endif

  let branch = autocommit#git#query_branch(path)
  if len(branch) == 0
    " Unexpected.
    return
  endif

  let branch_prefix = autocommit#git#get_config(
    \   path, "vim_autocommit.branch_prefix"
    \ )
  if !autocommit#git#starts_with(branch, branch_prefix)
    " Not allowed in this branch.
    return
  endif

  " Compose commit message.
  let relpath = path[len(gittop) + 1 :]
  let stats = autocommit#git#diff_stats(path)
  if len(stats) == 0
    let msg = 'Add ' . relpath
  else
    let dels = stats[0]
    let adds = stats[1]
    let msg = 'Change ' . relpath .  ' (-' . dels . '/+' . adds . ' lines)'
  endif
  let msg = g:autocommit_message_prefix . msg

  call autocommit#git#commit(path, msg)
endfunction
