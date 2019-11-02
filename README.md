# vim-varnish

Vim and Neovim syntax highlighting support for Varnish Configuration
Language (VCL).

## Installation

### Using vim-plug

* Add `Plug 'fgsch/vim-varnish'` to `~/.vimrc`
* `:PlugInstall` or `$ vim +PlugInstall +qall`

### Using Pathogen

* `git clone --depth=1 https://github.com/fgsch/vim-varnish ~/.vim/bundle/vim-varnish`

## Features

### Folding

Setting `g:vcl_fold` enables folding VCL via the syntax engine.
Any block, comment, or inline-C that extends over more than one
line can be folded using the standard Vim and Neovim fold-commands.

This option is off by default.

```
" Default
let g:vcl_fold = 0
```

## License

This plugin is licensed under BSD license. See LICENSE for details.
