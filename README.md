# nim-notcurses

[![License: Apache](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![ABI: stable](https://img.shields.io/badge/ABI-stable-green.svg?color=2dbd42)](https://github.com/michaelsbradleyjr/nim-notcurses#stability)
[![API: experimental](https://img.shields.io/badge/API-experimental-orange.svg)](https://github.com/michaelsbradleyjr/nim-notcurses#stability)
[![Tests (GitHub Actions)](https://github.com/michaelsbradleyjr/nim-notcurses/workflows/Tests/badge.svg?branch=version_3_revamp_2)](https://github.com/michaelsbradleyjr/nim-notcurses/actions?query=workflow%3ATests+branch%3Aversion_3_revamp_2)

Nim wrapper for [Notcurses](https://github.com/dankamongmen/notcurses#readme): blingful TUIs and character graphics.

The wrapper builds and exposes Notcurses' raw C API via [nimterop](https://github.com/nimterop/nimterop#readme).

## Under construction

:construction: nim-notcurses needs significant work for Notcurses to be fully usable and for Nim programs using the wrapper to be stable. Please keep that in mind if you decide to experiment with this package.

:crystal_ball: A complete overhaul has been in progress for some time on the [version_3_revamp](https://github.com/michaelsbradleyjr/nim-notcurses/tree/version_3_revamp) branch. When complete, nim-notcurses will provide both a proper Nim API and a lower-level wrapper for Notcurses' C ABI. Builds are being [tested](https://github.com/michaelsbradleyjr/nim-notcurses/actions?query=workflow%3ATests+branch%3Aversion_3_revamp) on Linux, macOS, and Windows.

## Requirements

Same as Notcurses' [requirements](https://github.com/dankamongmen/notcurses#requirements).

:package: Notcurses v3 needs to be installed with your package manager, or you can compile and install it from source.

If the headers and compiled libraries are not in locations well known to your system's compiler and linker, you may need to use `--passC` and/or `--passL` with `nim c`.

:crystal_ball: In the future it will be possible to pass `-d:downloadNotcurses` to `nim c` and have the matching version of Notcurses downloaded and compiled on the fly, and then statically linked to your compiled Nim program.

## Usage

### Import

```nim
import notcurses
```

Or import its minimal core:

```nim
import notcurses/core
```

#### CLI mode

```nim
import notcurses/cli
```

Or import its minimal core:

```nim
import notcurses/core/cli
# or: import notcurses/cli/core
```

#### Direct mode

```nim
import notcurses/direct
```

Or import its minimal core:

```nim
import notcurses/core/direct
# or: import notcurses/direct/core
```

:coffin: Direct mode is deprecated in Notcurses v3, it's recommended to use CLI mode instead.

### Examples

See the modules in [examples/poc](https://github.com/michaelsbradleyjr/nim-notcurses/tree/version_3_revamp_2/examples/poc).

```
$ nim c examples/poc/cli1.nim && examples/poc/cli1
```

Can be compiled and run with the `-r` option instead, but running as a child process may interfere with input/output.

```
$ nim c -r examples/poc/cli1.nim
```

### ABI

If you don't fancy the Nim API provided by this package, you can import its lower-level wrapper for Notcurses' C ABI and work with that directly, or use it to build an API to your liking.

```nim
import notcurses/abi
```
```nim
import notcurses/abi/core
# or: import notcurses/core/abi
```
```nim
import notcurses/abi/direct
# or: import notcurses/direct/abi
```
```nim
import notcurses/abi/core/direct
# or: import notcurses/abi/direct/core
# or: import notcurses/core/abi/direct
# or: ...
```

## Versioning

This package follows the [version number](https://github.com/dankamongmen/notcurses/releases) of Notcurses:
* currently [`v3.TBD`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/TBD) (upstream: [`v3.TBD`](https://github.com/dankamongmen/notcurses/releases/tag/TBD))
* beginning with [`v2.3.13`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v2.3.13) (upstream: [`v2.3.13`](https://github.com/dankamongmen/notcurses/releases/tag/v2.3.13)).

:bulb: It's recommended to only use version `>= v3.TBD` of *this package*. Earlier versions were too raw and unproven.

Starting with [`v3.TBD`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/TBD) the implementation was overhauled, with Notcurses' examples and demo ported to the Nim API and tested to compile and run correctly on various platforms.

## Stability

Notcurses' C ABI is stable per major version, and this package's lower-level wrapper for it is likewise stable.

The Nim API provided by this package is currently marked as experimental. Until it is marked as stable, it may be subject to breaking changes across patch and minor versions.

## License

### Wrapper license

nim-notcurses is licensed and distributed under either of:

* Apache License, Version 2.0: [LICENSE-APACHEv2](LICENSE-APACHEv2) or https://opensource.org/licenses/Apache-2.0
* MIT license: [LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT

at your option. The contents of this repository may not be copied, modified, or distributed except according to those terms.

### Dependency license

Notcurses is [licensed](https://github.com/dankamongmen/notcurses/blob/master/COPYRIGHT) under the Apache License, Version 2.0.
