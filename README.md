# nim-notcurses

[![License: Apache](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![ABI wrapper: stable](https://img.shields.io/badge/ABI%20wrapper-stable-green.svg?color=2dbd42)](#stability)
[![API: experimental](https://img.shields.io/badge/API-experimental-orange.svg)](#stability)
[![Builds (GitHub Actions)](https://github.com/michaelsbradleyjr/nim-notcurses/workflows/Builds/badge.svg?branch=version_3_revamp)](https://github.com/michaelsbradleyjr/nim-notcurses/actions?query=workflow%3ABuilds+branch%3Aversion_3_revamp)

Nim wrapper for [Notcurses](https://github.com/dankamongmen/notcurses#readme): blingful TUIs and character graphics.

This package provides a Nim API and a low-level wrapper for Notcurses' raw C API.

---

:construction: [`version_3_revamp`](https://github.com/michaelsbradleyjr/nim-notcurses/tree/version_3_revamp) is a work in progress, its changes are not yet included in any tagged version. What follows includes forward-looking statements.

---

## Installation

Check [requirements](#requirements), then add [`notcures`](https://nimble.directory/pkg/notcurses) to a project's [`.nimble`](https://github.com/nim-lang/nimble#readme) file

<!--
```nim
requires "notcurses >= 3.TBD & < 4.0.0"
```
-->

```nim
requires "notcurses#version_3_revamp"
```

:construction: These instructions will be revised once changes in [`version_3_revamp`](https://github.com/michaelsbradleyjr/nim-notcurses/tree/version_3_revamp) are included in a tagged version.

[choosenim](https://github.com/dom96/choosenim#readme) is a convenient way to install the Nim compiler and tools, if you don't have them installed already.

## Usage

### API

```nim
import notcurses
```

Or import its minimal core

```nim
import notcurses/core
```

:bulb: The *minimal core* does not link against Notcurses' multimedia stack, as explained in its [FAQs](https://github.com/dankamongmen/notcurses#faqs).

#### CLI mode

```nim
import notcurses/cli
```

Or import its minimal core

```nim
import notcurses/cli/core
```

#### Direct mode

```nim
import notcurses/direct
```

Or import its minimal core

```nim
import notcurses/direct/core
```

:bulb: It's generally recommended to use [CLI mode](#cli-mode) instead of Direct mode. See Notcurses' [FAQs](https://github.com/dankamongmen/notcurses#faqs), and for more context see [dankamongmen/notcurses#1853](https://github.com/dankamongmen/notcurses/discussions/1853) and [dankamongmen/notcurses#1834](https://github.com/dankamongmen/notcurses/issues/1834).

### ABI wrapper

If you don't fancy the Nim API provided by this package, you can import its low-level wrapper for Notcurses' raw C API and work with that directly, or use it to build an API to your liking.

```nim
import notcurses/abi
```

Or import its minimal core

```nim
import notcurses/abi/core
```

## Examples

See the modules in [`examples`](examples). To build and run the [`cli1`](examples/cli1.nim) example do

```text
$ nim c -r examples/cli1.nim
```

You can use additional options, cf. [requirements](#requirements).

```text
$ nim c --passC:"-I${HOME}/repos/notcurses/include" \
        --passL:"-L${HOME}/repos/notcurses/build -rpath ${HOME}/repos/notcurses/build" \
        -r examples/cli1.nim
```

## Requirements

Notcurses needs to be installed with your package manager :package:, or you can compile it from source.

For example, on macOS, you could install it with [`brew`](https://brew.sh/)

```text
$ brew install notcurses
```

### 🍻 BYO Notcurses

Building Notcurses is simple, but make sure to have its [requirements](https://github.com/dankamongmen/notcurses#requirements) installed.

For example, on Linux or macOS, you could do it like this

```text
$ git clone --depth 1 https://github.com/dankamongmen/notcurses.git \
            --branch v3.0.9 \
            "${HOME}/repos/notcurses"
$ cd "${HOME}/repos/notcurses"
$ mkdir build && cd build
$ cmake .. -DCMAKE_BUILD_TYPE=Release
$ make -j16
```

On Windows + [MSYS2](https://www.msys2.org/), add `-G"MSYS Makefiles"` to the `cmake` command.

:bulb: `make install` should not be run after `make` *unless* you want to install your own Notcurses build system-wide.

### 👑 Compiler options

If you build Notcurses yourself and don't install it system-wide, then its headers and libraries will not be in locations known to your compiler and linker. In that case, use `--passC` and `--passL` with `nim c`.

For example, on macOS, if your own build of Notcurses is in `${HOME}/repos/notcurses/build`, you would use

```text
$ nim c --passC:"-I${HOME}/repos/notcurses/include" \
        --passL:"-L${HOME}/repos/notcurses/build -rpath ${HOME}/repos/notcurses/build" \
        ...
```

On Linux and Windows, drop the `-rpath` option.

:bulb: Be careful to not have a system-wide installation of Notcurses while attempting to link against your own *non-installed* build of it, else you may experience mysterious problems and frustrations 😵

### Windows

Support for Microsoft Windows is a bit anemic at present, but that has nothing to do with Nim, rather [Windows Terminal](https://github.com/microsoft/terminal#readme) and Notcurses' support for it are works in progress.

All of the examples can be built and run on Windows + [MSYS2](https://www.msys2.org/), but:
* Programs should be built in an MSYS2 shell and run in [Windows Terminal](https://github.com/microsoft/terminal#readme) in an MSYS2 shell; they will not run correctly in [Mintty](https://mintty.github.io/). It's easy to configure Windows Terminal to launch an MSYS2 shell, see [these instructions](https://www.msys2.org/docs/terminals/).
* DLLs for Notcurses must be in your MSYS2 shell's path at runtime, e.g.<br />`export PATH="${HOME}/repos/notcurses/build:${PATH}"`
* Windows' system locale needs to be set to [UTF-8](https://en.wikipedia.org/wiki/UTF-8):<br />*Language settings -> Administrative language settings -> Change system locale -> Beta: Use Unicode UTF-8 for worldwide language support*
* Expect to encounter rendering bugs and for performance to be lackluster.

:bulb: Programs using nim-notcurses build correctly in GitHub Actions on Windows + MSYS2, but are known to *not* run successfully in that CI environment.

## Goals

* Provide a comprehensive wrapper for Notcurses' raw C API, and keep it up-to-date as Notcurses evolves.
* Offer a higher-level API built atop the lower-level wrapper, allowing Notcurses to be readily leveraged with the language features of Nim.

The high-level API is referred to as a *Nim API* elsewhere in this document and repository, for want of a better description.

In the future, it may be desirable to split this project into two packages: `notcurses` and `notcurses_abi`. The latter would be a dependency of the former. At present, it makes sense to develop the wrappers together as a single package.

**Non-goals:** provide an extensible widgets or charting library, a text-based windowing system, or other advanced facilities that could be built with nim-notcurses. Such ideas can be explored in projects that have this package as a dependency.

## Versioning

This package follows the [version number](https://github.com/dankamongmen/notcurses/releases) of Notcurses:
* currently [`v3.TBD`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/TBD) (upstream: [`v3.TBD`](https://github.com/dankamongmen/notcurses/releases/tag/TBD))
* beginning with [`v2.3.13`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v2.3.13) (upstream: [`v2.3.13`](https://github.com/dankamongmen/notcurses/releases/tag/v2.3.13)).

:bulb: It's recommended to only use version `>= 3.TBD` of *this package*. Earlier versions of *nim-notcurses* were too raw and unproven.

Starting with [`v3.TBD`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/TBD) the implementation of nim-notcurses was overhauled, with Notcurses' examples and demo ported to the Nim API and tested to compile and run correctly on various platforms.

## Stability

Notcurses' ABI is stable per major version, and this package's low-level wrapper is likewise stable as of version `>= 3.TBD`, cf. [versioning](#versioning).

The Nim API (high-level wrapper) provided by this package is currently marked as experimental. Until it is marked as stable, it may be subject to breaking changes across patch and minor versions.

## License

nim-notcurses is licensed and distributed under either of:

* Apache License, Version 2.0: [LICENSE-APACHEv2](LICENSE-APACHEv2) or [https://opensource.org/licenses/Apache-2.0](https://opensource.org/licenses/Apache-2.0)
* MIT License: [LICENSE-MIT](LICENSE-MIT) or [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)

at your option. The contents of this repository may not be copied, modified, or distributed except according to those terms.

### Dependency license

Notcurses is [licensed](https://github.com/dankamongmen/notcurses/blob/v3.0.9/COPYRIGHT) under the Apache License, Version 2.0: [LICENSE-NOTCURSES](LICENSE-NOTCURSES).
