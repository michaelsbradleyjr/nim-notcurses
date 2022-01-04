# nim-notcurses

[![License: Apache](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Stability: experimental](https://img.shields.io/badge/Stability-experimental-orange.svg)](https://github.com/michaelsbradleyjr/nim-notcurses#nim-notcurses)

Nim wrapper for [Notcurses](https://github.com/dankamongmen/notcurses#readme): blingful TUIs and character graphics.

This package provides a Nim API and a lower-level wrapper for Notcurses' C ABI.

## Requirements

Same as Notcurses' [requirements](https://github.com/dankamongmen/notcurses#requirements).

:package: Notcurses v3 needs to be installed with your package manager, or you can compile and install it from source.

If the headers and compiled libraries are not in locations well known to your system's compiler and linker, you may need to use `--passC` and/or `--passL` with `nim c`.

:crystal_ball: In the future it will be possible to pass `-d:downloadNotcurses` to `nim c` and have the matching version of Notcurses downloaded and compiled on the fly, and then statically linked to the compiled Nim program.

## Usage

### Import

```nim
import notcurses
```

Or import its minimal core:

```nim
import notcurses/core
```

CLI mode:

```nim
import notcurses/cli
```

Or import its minimal core:

```nim
import notcurses/core/cli
```

Direct mode:

```nim
import notcurses/direct
```

Or import its minimal core:

```nim
import notcurses/core/direct
```

:coffin: Direct mode is deprecated in Notcurses v3, it's recommended to use CLI mode instead.

### Examples

See the modules in [examples/poc](https://github.com/michaelsbradleyjr/nim-notcurses/tree/version_3_revamp/examples/poc).

```
$ nim c examples/poc/cli1.nim && examples/poc/cli1
```

Can be compiled and run in one step with the `-r` option, but running as a child process may interfere with input/output.

```
$ nim c -r examples/poc/cli1.nim
```

## Versioning

This package follows the [version number](https://github.com/dankamongmen/notcurses/releases) of Notcurses:
* currently [`v3.TBD`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/TBD) (upstream: [`v3.TBD`](https://github.com/dankamongmen/notcurses/releases/tag/TBD))
* beginning with [`v2.3.13`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v2.3.13) (upstream: [`v2.3.13`](https://github.com/dankamongmen/notcurses/releases/tag/v2.3.13)).

:bulb: It's recommended to only use version `>= v3.TBD` of *this package*. Earlier versions were unproven and too raw.

Starting with [`v3.TBD`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/TBD) the implementation was overhauled, with Notcurses' examples and demo ported to the Nim API and tested to compile and run correctly on various platforms.

:construction: Since this Nim package is still experimental and not widely used, it may be possible to backport the work for `v3.TBD` to support older Notcurses `v2.x` and `v3.x`, and then rewrite the history of `master` and tags for this repo. *Stay tuned!*

## License

### Wrapper license

nim-notcurses is licensed and distributed under either of:

* Apache License, Version 2.0: [LICENSE-APACHEv2](LICENSE-APACHEv2) or https://opensource.org/licenses/Apache-2.0
* MIT license: [LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT

at your option. The contents of this repository may not be copied, modified, or distributed except according to those terms.

### Dependency license

Notcurses is [licensed](https://github.com/dankamongmen/notcurses/blob/master/COPYRIGHT) under the Apache License, Version 2.0.
