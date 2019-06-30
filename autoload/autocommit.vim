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
"   vim-autocommit.enabled
"   vim-autocommit.branch-prefix
"
function! autocommit#do_autocommit(bufnr) abort
  if getbufvar(a:bufnr, 'autocommit_disabled', 0)
    return
  endif

  let path = resolve(expand('#' . a:bufnr . ':p'))

  let gittop = autocommit#git#query_topdir(path)
  if len(gittop) == 0
    return
  endif

  let enabled = autocommit#git#get_config(path, "vim-autocommit.enabled")
  if enabled != 1
    return
  endif

  let branch = autocommit#git#query_branch(path)
  if len(branch) == 0
    throw "cannot identify brnach"
  endif

  " Prefix-based whitelisting.
  let branch_prefix = autocommit#git#get_config(
    \   path, "vim-autocommit.branch-prefix"
    \ )
  if !autocommit#utils#starts_with(branch, branch_prefix)
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
