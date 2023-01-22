# nim-notcurses

[![License: Apache](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![ABI: stable](https://img.shields.io/badge/ABI-stable-green.svg?color=2dbd42)](https://github.com/michaelsbradleyjr/nim-notcurses#stability)
[![API: experimental](https://img.shields.io/badge/API-experimental-orange.svg)](https://github.com/michaelsbradleyjr/nim-notcurses#stability)
[![Tests (GitHub Actions)](https://github.com/michaelsbradleyjr/nim-notcurses/workflows/Tests/badge.svg?branch=version_3_revamp)](https://github.com/michaelsbradleyjr/nim-notcurses/actions?query=workflow%3ATests+branch%3Aversion_3_revamp)

Nim wrapper for [Notcurses](https://github.com/dankamongmen/notcurses#readme): blingful TUIs and character graphics.

This package provides a Nim API and a lower-level wrapper for Notcurses' C ABI.

## Requirements

Same as Notcurses' [requirements](https://github.com/dankamongmen/notcurses#requirements).

:package: Notcurses v3 needs to be installed with your package manager, or you can compile and install it from source.

If the headers and compiled libraries are not in locations well known to your system's compiler and linker, you may need to use `--passC` and/or `--passL` with `nim c`.

For example, on macOS, if Notcurses is built in `${HOME}/repos/notcurses/build`, you would use:
```text
$ nim c --passC:"-I${HOME}/repos/notcurses/include" \
        --passL:"-rpath ${HOME}/repos/notcurses/build" \
        ...
```

Be careful to not have a system-wide installation of Notcurses while attempting to link against your own non-installed build of it, else you may experience mysterious and hard to debug errors.

### BYO Notcurses

Building Notcurses is simple, but make sure to have its [requirements](https://github.com/dankamongmen/notcurses#requirements) installed.

For example, on macOS, you could do it like this, taking advantage of multiple cores when running `make`:

```text
$ git clone https://github.com/dankamongmen/notcurses.git "${HOME}/repos/notcurses"
$ cd "${HOME}/repos/notcurses" && mkdir build && cd build
$ cmake .. -DCMAKE_BUILD_TYPE=Release
$ make -j16
```

## Usage

### Import

```nim
import notcurses
```

Or import its minimal core:

```nim
import notcurses/core
```

:bulb: The *"minimal core"* does not link against Notcurses' multimedia stack, as explained in its [FAQs](https://github.com/dankamongmen/notcurses#faqs).

#### CLI mode

```nim
import notcurses/cli
```

Or import its minimal core:

```nim
import notcurses/cli/core
```

#### Direct mode

Notcurses' Direct mode is not supported by this package, it's recommended to use CLI mode instead. For more context see [dankamongmen/notcurses#1834](https://github.com/dankamongmen/notcurses/issues/1834).

### Examples

See the modules in [examples/poc](https://github.com/michaelsbradleyjr/nim-notcurses/tree/version_3_revamp/examples/poc).

```text
$ nim c -r examples/poc/cli1.nim
```

You can use or add other options, cf. *[Requirements](#requirements)*.

```text
$ nim c --passC:"-I${HOME}/repos/notcurses/include" \
        --passL:"-rpath ${HOME}/repos/notcurses/build" \
        examples/poc/cli1.nim
```

### ABI

If you don't fancy the Nim API provided by this package, you can import its lower-level wrapper for Notcurses' C ABI and work with that directly, or use it to build an API to your liking.

```nim
import notcurses/abi
```

Or import its minimal core:

```nim
import notcurses/abi/core
```

## Versioning

This package follows the [version number](https://github.com/dankamongmen/notcurses/releases) of Notcurses:
* currently [`v3.TBD`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/TBD) (upstream: [`v3.TBD`](https://github.com/dankamongmen/notcurses/releases/tag/TBD))
* beginning with [`v2.3.13`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v2.3.13) (upstream: [`v2.3.13`](https://github.com/dankamongmen/notcurses/releases/tag/v2.3.13)).

:bulb: It's recommended to only use version `>= v3.TBD` of *this package*. Earlier versions of nim-notcurses were too raw and unproven.

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
