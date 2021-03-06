# nim-notcurses

[![License: Apache](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Stability: experimental](https://img.shields.io/badge/Stability-experimental-orange.svg)](https://github.com/michaelsbradleyjr/nim-notcurses#nim-notcurses)

A low-level Nim wrapper for [Notcurses](https://github.com/dankamongmen/notcurses#readme): blingful TUIs and character graphics.

The wrapper builds and exposes Notcurses' raw C API via [nimterop](https://github.com/nimterop/nimterop#readme).

## Under construction

:construction: nim-notcurses needs significant work for Notcurses to be fully usable and for Nim programs using the wrapper to be stable. Please keep that in mind if you decide to experiment with this package.

:crystal_ball: A complete overhaul has been in progress for some time on the [version_3_revamp](https://github.com/michaelsbradleyjr/nim-notcurses/tree/version_3_revamp) branch. When complete, nim-notcurses will provide both a proper Nim API and a lower-level wrapper for Notcurses' C ABI. Builds are being [tested](https://github.com/michaelsbradleyjr/nim-notcurses/actions?query=workflow%3ATests+branch%3Aversion_3_revamp) on Linux, macOS, and Windows.

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

Make sure to pass the desired options to nimterop and the compiler, e.g on macOS:

```
$ mkdir -p build
$ nim c \
  -d:release \
  --passL:"-rpath ${PWD}/build -L${PWD}/build -lnotcurses-core.3" \
  --outdir:build \
  examples/hello_cli.nim

$ build/hello_cli
```

There are additional options that can be set; see [nimterop's README](https://github.com/nimterop/nimterop#readme) and the `{.strdefine.}` constants in e.g. [`notcurses.nim`](https://github.com/michaelsbradleyjr/nim-notcurses/blob/master/notcurses.nim) and [`notcurses/includes/generator_top.nim`](https://github.com/michaelsbradleyjr/nim-notcurses/blob/master/notcurses/includes/generator_top.nim).

For information on how to work with Notcurses, see its [Usage](https://github.com/dankamongmen/notcurses/blob/master/USAGE.md#usage) doc.

In time, this repo will likely provide guidance specific to programming with the wrapper, and it may eventually supply a more Nim-oriented API that is backed by the wrapper.

## Versioning

This library follows the [version number](https://github.com/dankamongmen/notcurses/releases) of Notcurses:
* currently [`v3.0.7`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v3.0.7) (upstream: [`v3.0.7`](https://github.com/dankamongmen/notcurses/releases/tag/v3.0.7))
* beginning with [`v2.3.13`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v2.3.13) (upstream: [`v2.3.13`](https://github.com/dankamongmen/notcurses/releases/tag/v2.3.13)).

## License

### Wrapper license

nim-notcurses is licensed and distributed under either of:

* Apache License, Version 2.0: [LICENSE-APACHEv2](LICENSE-APACHEv2) or https://opensource.org/licenses/Apache-2.0
* MIT license: [LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT

at your option. The contents of this repository may not be copied, modified, or distributed except according to those terms.

### Dependency license

Notcurses is [licensed](https://github.com/dankamongmen/notcurses/blob/master/COPYRIGHT) under the Apache License, Version 2.0.
