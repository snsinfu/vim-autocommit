" Determines if str starts with prefix.
"
" Args:
"   str
"   prefix
"
" Returns:
"   True if str starts with prefix. True is returned if prefix is empty.
"
function! autocommit#utils#starts_with(str, prefix) abort
  if len(a:prefix) == 0
    return v:true
  endif
  return len(a:str) >= len(a:prefix) && a:str[: len(a:prefix) - 1] == a:prefix
endfunction
