vim-autocommit
==============

`vim-autocommit` automatically commits changes to git-managed files edited in
vim. Useful when fiddling in a feature branch. Commit log would look like this:

```
f25c813 wip! Change foo.c (-2/+9 lines)
bc16dd9 wip! Change bar.c (-9/+15 lines)
c54bce8 wip! Change bar.c (-2/+5 lines)
12c4d1a wip! Change foo.c (-0/+20 lines)
1a2cb2a wip! Add foo.c
```

## Install

If you use vim-plug:

```vim
Plug 'snsinfu/vim-autocommit'
```

## Usage

Autocommit is _not_ enabled by default. Enable it by setting the following git
config entries to your repository:

```sh
git config --local vim-autocommit.enabled 1
git config --local vim-autocommit.branch-prefix "hack-"
```

Setting `branch-prefix` entry restricts autocommit to only happen in branches
starting with the configured prefix (`hack-` here). You may want to work in a
"hacking branch" and squash-merge the changes to a main branch later.

## Customization

By default autocommit is triggered when leaving from a buffer. You can change
this behavior by clearing and setting autocmds in vimrc. Examples:

```vim
" Autocommit on save.
au! autocommit
au BufWritePost * AutoCommit
```

```vim
" Autocommit when + key is pressed in normal mode.
au! autocommit
nn + :AutoCommit<cr>
```

## Development status

Experimental. I'm using this plugin myself to see if the idea works. If it
works, I will bump the version to 1.0 and continue the development.

## License

MIT License.
