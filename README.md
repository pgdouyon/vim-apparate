Apparate
========

Apparate is a plugin that adds additional text objects to Vim to teleport to
the next/previous text object similar to [targets.vim][].

Apparate mainly focuses on the "pair" text objects (i.e. (),[],{},<>,'',""),
but also provides mappings for operating within separators such as pipes,
commas, colons, periods, etc.

Operate on remote text objects using either `in`, `an`, `il`, or `al` operator
mappings followed by the pair/separator to operate on.
    - i.e. `dan<`, `cilb`, `=in{`, `yal|`

Installation
------------

* [Pathogen][]
    * `cd ~/.vim/bundle && git clone https://github.com/pgdouyon/vim-niffler.git`
* [Vim-Plug][]
    * `Plug 'pgdouyon/vim-niffler'`
* Manual Install
    * Copy all the files into the appropriate directory under `~/.vim` on \*nix or
      `$HOME/_vimfiles` on Windows


License
-------

Copyright (c) 2015 Pierre-Guy Douyon.  Distributed under the MIT License.


[targets.vim]: https://github.com/wellle/targets.vim
[Pathogen]: https://github.com/tpope/vim-pathogen
[Vim-Plug]: https://github.com/junegunn/vim-plug
