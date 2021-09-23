# Ant

Ant is a new typesetting system written by Achim Blumensath. It resembles TeX,
but improves the internal language, which is ML dialect with rich domain-specific
features for typesetting. For more information read the [MANUAL.PDF](https://github.com/5HT/ant/blob/master/manual.pdf).

## Features

* TeX syntax
* Unicode support
* Font Support: Type1, TrueType, and OpenType
* Color and Graphics
* Simple Page Layout Specifications
* ML-like typesetting language

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
