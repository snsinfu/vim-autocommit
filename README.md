vim-autocommit
==============

Experimental git auto-commit plugin for vim.

vim-autocommit lets every file edited in vim automatically commited to git
repository. This is an experiment on the idea that one commits changes often
and squash the commits later. Like this:

```console
$ git rebase -i HEAD~5
squash f25c813 wip! Change foo.c (-2/+9 lines)
squash bc16dd9 wip! Change foo.c (-9/+15 lines)
squash c54bce8 wip! Change bar.c (-2/+5 lines)
squash 12c4d1a wip! Change foo.c (-0/+20 lines)
pick   1a2cb2a wip! Add foo.c
↓
Add cool foo widget
```

## Install

With vim-plug:

```vim
Plug 'snsinfu/vim-autocommit'
```

## Configurations

```vim
" Change autocommit message prefix. Useful for squashing commits later.
let g:autocommit_message_prefix = 'wip! '

" Only autocommit in branches whose name is prefixed by this string. Set this
" to 'dev-' for example to prevent autocommit in the master branch.
let g:autocommit_branch_prefix = 'dev-'

" Do not autocommit markdown. Note the b: prefix. This is buffer-local.
au FileType markdown let b:autocommit_disabled = 1

" Do not autocommit on save. You can still trigger :AutoCommit manually.
let g:autocommit_on_save = 0
```

## Advanced configurations

### Autocommit on leave

Disable autocommit on save, and instead let autocommit happen when leaving a
buffer. This would be useful when you are using an autosave plugin.

```vim
let g:autocommit_on_save = 0
au BufLeave * AutoCommit
```

### Map :w to autocommit

More aggressively, you can remap `:w` to do autocommit instead of save.

```vim
Plug 'snsinfu/vim-autocommit'
Plug 'vim-scripts/vim-auto-save'
...
let g:autocommit_on_save = 0
let g:auto_save = 1
set nocompatible
ca w <c-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'AutoCommit' : 'w')<cr>
```

## License

MIT License.
