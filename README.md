# Ant

Ant is a new typesetting system written by Achim Blumensath. It resembles TeX,
but improves the internal language, which is ML dialect with rich domain-specific
features for typesetting. For more information read the [MANUAL.PDF](https://github.com/5HT/ant/blob/master/manual.pdf).

## Features

* TeX syntax
* Unicode support
* Font Support: Type1, TrueType, and OpenType
* Simple Page Layout Specifications
* Color and Graphics
* Hyphenation System
* ML-like typesetting language

## Building

```sh
$ opam switch install 4.11.2
$ opam install ocamlfind omake zlib camlimages
```

```sh
$ omake Runtime/freetype-stubs.o
$ omake Runtime/kpathsea-stubs.o
$ omake Unicode/Tables.o
$ omake
```

## Credits

* Achim Blumensath (author)
* Gabriel Scherer
* Maxim Sokhatsky
