# Ant

Ant is a new typesetting system written by Achim Blumensath. It resembles TeX,
but improves the internal language, which is ML dialect with rich domain-specific
features for typesetting. For more information please take a look at
the [MANUAL.PDF](https://github.com/5HT/ant/blob/master/manual.pdf)

## Features

* Unicode support;
* support for various font formats including Type1, TrueType, and OpenType;
* partial support for advanced OpenType features;
* support for colour and graphics;
* simple page layout specifications;

## Building

```sh
$ opam switch install 4.11.2
$ opam install ocamlfind
$ opam install omake
$ opam install zlib
$ opam install camlimages
```

```sh
$ omake
```

## Credits

* Achim Blumensath (author)
* Gabriel Scherer
* Maxim Sokhatsky
