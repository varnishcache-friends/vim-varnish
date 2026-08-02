# vim-varnish

Vim and Neovim syntax highlighting support for the Varnish and Vinyl Cache
Configuration Language (VCL).

## Installation

### lazy.nvim

Add this plugin spec to your Neovim configuration:

```lua
return {
  "varnishcache-friends/vim-varnish",
  lazy = false,
}
```

`lazy = false` keeps the filetype detection available at startup.

### vim-plug

* Add `Plug 'varnishcache-friends/vim-varnish'` to `~/.vimrc`
* `:PlugInstall` or `$ vim +PlugInstall +qall`

## Features

### Folding

Setting `g:vcl_fold` enables folding VCL via the syntax engine.
Any block, comment, or inline-C that extends over more than one
line can be folded using the standard Vim and Neovim fold-commands.

This option is off by default.

```vim
" Default
let g:vcl_fold = 0
```

## Tests

Run the syntax-highlighting tests with:

```sh
./test/run.sh
```

To run them with Neovim:

```sh
VIM_BIN=nvim ./test/run.sh
```

## License

This plugin is licensed under BSD License. See LICENSE for details.
