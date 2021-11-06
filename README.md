# nim-notcurses

[![License: Apache](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Stability: experimental](https://img.shields.io/badge/Stability-experimental-orange.svg)](https://github.com/michaelsbradleyjr/nim-notcurses#nim-notcurses)

A low-level Nim wrapper for [Notcurses](https://github.com/dankamongmen/notcurses#readme): blingful TUIs and character graphics.

The wrapper builds and exposes Notcurses' raw C API via [nimterop](https://github.com/nimterop/nimterop#readme).

## :construction: Under construction :construction:

The wrapper may need significant fine-tuning for Notcurses to be fully usable and for Nim programs using the wrapper to be stable. Please keep that in mind if you decide to experiment with nim-notcurses.

## Requirements

Same as Notcurses' [requirements](https://github.com/dankamongmen/notcurses#requirements).

## Usage

```nim
import notcurses
```

Or import the minimal core:

```nim
import notcurses/core
```

For direct mode:

```nim
import notcurses/direct
```

Or import its minimal core:

```nim
import notcurses/core/direct
```

### Compiling

Make sure to pass the desired options to nimterop:

```
$ mkdir -p build
$ nim c \
  -d:notcursesDl \
  -d:danger -d:strip --hints:off --opt:size --passC:-flto --passL:-flto \
  --outdir:build \
  examples/hello_direct.nim

$ build/hello_direct
```

`-d:notcursesDl` configures nimterop to download Notcurses' sources from GitHub. There are additional options that can be set; see [nimterop's README](https://github.com/nimterop/nimterop#readme) and the `{.strdefine.}` constants in e.g. [`notcurses.nim`](https://github.com/michaelsbradleyjr/nim-notcurses/blob/master/notcurses.nim) and [`notcurses/includes/generator_top.nim`](https://github.com/michaelsbradleyjr/nim-notcurses/blob/master/notcurses/includes/generator_top.nim).

For information on how to work with Notcurses, see its [Usage](https://github.com/dankamongmen/notcurses/blob/master/USAGE.md#usage) doc.

In time, this repo will likely provide guidance specific to programming with the wrapper, and it may eventually supply a more Nim-oriented API that is backed by the wrapper.

## Versioning

This library follows the [version number](https://github.com/dankamongmen/notcurses/releases) of Notcurses:
* currently [`v2.4.6`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v2.4.6) (upstream: [`v2.4.6`](https://github.com/dankamongmen/notcurses/releases/tag/v2.4.6))
* beginning with [`v2.3.13`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v2.3.13) (upstream: [`v2.3.13`](https://github.com/dankamongmen/notcurses/releases/tag/v2.3.13)).

## License

### Wrapper license

nim-notcurses is licensed and distributed under either of:

* Apache License, Version 2.0: [LICENSE-APACHEv2](LICENSE-APACHEv2) or https://opensource.org/licenses/Apache-2.0
* MIT license: [LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT

at your option. The contents of this repository may not be copied, modified, or distributed except according to those terms.

### Dependency license

Notcurses is [licensed](https://github.com/dankamongmen/notcurses/blob/master/COPYRIGHT) under the Apache License, Version 2.0.
