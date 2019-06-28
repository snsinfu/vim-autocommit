" Returns git top directory for the path.
"
" Args:
"   path - Path to a file or a directory in a git work tree.
"
" Returns:
"   Git top directory containing the path. Empty string is returned if the
"   path is not under a git working tree.
"
function! autocommit#git#query_topdir(path) abort
  let dir = fnamemodify(a:path, ':h')
  let cmd =
    \ 'cd ' . shellescape(dir) . ' &&' .
    \ 'git rev-parse --show-toplevel'
  let gittop = trim(system(cmd))

  if len(gittop) == 0
    return ''
  endif

  return gittop
endfunction


" Returns the local git config.
"
" Args:
"   path - Path to a file or a directory in a git work tree.
"   key  - Config key.
"
" Returns:
"   The config value associated with the key. Empty string is returned path is
"   not under a git work tree or the config key does not exist.
"
function! autocommit#git#get_config(path, key) abort
  let dir = fnamemodify(a:path, ':h')
  let cmd =
    \ 'cd ' . shellescape(dir) . ' &&' .
    \ 'git config --get ' . shellescape(a:key)
  let gitconfig = trim(system(cmd))

  if v:shell_error
    return ""
  endif

  return gitconfig
endfunction


" Returns the current branch name of the work tree containing specified path.
"
" Args:
"   path - Path to a file or a directory in a git work tree.
"
" Returns:
"   The current branch name. Empty string is returned if path is not under a
"   git work tree.
"
function! autocommit#git#query_branch(path) abort
  let dir = fnamemodify(a:path, ':p:h')
  let cmd =
    \ 'cd ' . shellescape(dir) . ' && ' .
    \ 'git rev-parse --abbrev-ref HEAD'
  return trim(system(cmd))
endfunction


" Computes the diff of specified file against git index and returns the number
" of deleted and added lines.
"
" Args:
"   path - Path to the file to examine.
"
" Returns:
"   List of the number of deleted lines and added lines. Empty list is
"   returned if the file is not changed or not tracked.
"
function! autocommit#git#diff_stats(path) abort
  " Run git-diff on the file.
  let dir = fnamemodify(a:path, ':h')
  let cmd =
    \ 'cd ' . shellescape(dir) . ' && ' .
    \ 'git --no-pager diff --no-ext-diff --no-color -U0 -- ' . shellescape(a:path)
  let diff = system(cmd)

  if len(diff) == 0
    return []
  endif

  " Parse unified diff output to get del/add stats of each hunk.
  " https://www.gnu.org/software/diffutils/manual/html_node/Detailed-Unified.html
  let dels = 0
  let adds = 0
  for line in split(diff, '\n')
    let matches = matchlist(line, '^@@\v -(\d+)(,\d+)? \+(\d+)(,\d+)?')
    if len(matches) > 0
      let dels += matches[2] == '' ? 1 : str2nr(matches[2][1:])
      let adds += matches[4] == '' ? 1 : str2nr(matches[4][1:])
    endif
  endfor

  return [dels, adds]
endfunction


" Commits file with given message msg. Nothing is done if file is not under
" git work tree.
"
" Args:
"   path - Path to the file to commit.
"   msg  - Commit message.
"
function! autocommit#git#commit(path, msg) abort
  let dir = fnamemodify(a:path, ':h')
  let cmd =
    \ 'cd ' . shellescape(dir) . ' && ' .
    \ 'git add ' . shellescape(a:path) . ' && ' .
    \ 'git commit -m ' . shellescape(a:msg) . ' ' . shellescape(a:path)
  call system(cmd)
endfunction
