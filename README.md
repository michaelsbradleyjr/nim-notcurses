# nim-notcurses

[![Nimble Package: notcurses](https://img.shields.io/github/v/tag/michaelsbradleyjr/nim-notcurses?filter=v*&logo=Nim&label=nimble&labelColor=black&color=f3d400)](https://nimble.directory/pkg/notcurses)
[![License: Apache-2.0](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Stability: experimental](https://img.shields.io/badge/Stability-experimental-orange.svg)](#stability)
[![Builds (GitHub Actions)](https://github.com/michaelsbradleyjr/nim-notcurses/actions/workflows/builds.yml/badge.svg?branch=master)](https://github.com/michaelsbradleyjr/nim-notcurses/actions?query=workflow%3ABuilds+branch%3Amaster)
[![codecov](https://codecov.io/gh/michaelsbradleyjr/nim-notcurses/branch/master/graph/badge.svg?token=VLN0VLATJS)](https://codecov.io/gh/michaelsbradleyjr/nim-notcurses)

[Nim](https://nim-lang.org) wrapper for [Notcurses](https://github.com/dankamongmen/notcurses#readme): blingful TUIs and character graphics.

This package provides a Nim API and a lower-level wrapper for Notcurses' raw C API.

---

:construction: changes in [`master`](https://github.com/michaelsbradleyjr/nim-notcurses/tree/master) since [`v3.0.9`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v3.0.9) involve a complete overhaul of nim-notcurses and are not yet included in any tagged version.

That overhaul is not complete, but in its current state is still more usable than previous versions. What follows includes forward-looking statements.

---

## Installation

Check [requirements](#requirements), then add [`notcures`](https://nimble.directory/pkg/notcurses) to a project's [`.nimble`](https://github.com/nim-lang/nimble#readme) file

<!--
```nim
requires "notcurses >= 3.N.N & < 4.0.0"
```
-->

```nim
requires "notcurses#head"
```

:construction: These instructions will be revised once changes in [`master`](https://github.com/michaelsbradleyjr/nim-notcurses/tree/master) are included in a tagged version.

[choosenim](https://github.com/dom96/choosenim#readme) is a convenient way to install the Nim compiler and tools, if you don't have them installed already.

## Usage

### API

```nim
import notcurses
```

or import its core

```nim
import notcurses/core
```

:bulb: The *core* does not link against Notcurses' multimedia stack, as explained in its [FAQs](https://github.com/dankamongmen/notcurses#faqs).

#### Initialization

*TUI mode* is the default and facilitates high-performance, non-scrolling, full-screen applications

```nim
let nc = Nc.init
```

#### Shutdown

```nim
nc.stop
```

#### CLI mode

*CLI mode* supports scrolling output for shell utilities, but with the full power of Notcurses

```nim
import notcurses
# or: import notcurses/core

let nc = Nc.init NcOpts.init [InitFlags.CliMode]

nc.stop
```

#### Direct mode

*Direct mode* makes a limited subset of Notcurses available for manipulating typical scrolling or file-backed output

```nim
import notcurses/direct
# or: import notcurses/direct/core

let ncd = Ncd.init

ncd.stop
```

:bulb: It's generally recommended to use [CLI mode](#cli-mode) instead of Direct mode. See Notcurses' [FAQs](https://github.com/dankamongmen/notcurses#faqs), and for more context see [dankamongmen/notcurses#1853](https://github.com/dankamongmen/notcurses/discussions/1853) and [dankamongmen/notcurses#1834](https://github.com/dankamongmen/notcurses/issues/1834).

### ABI

If you don't fancy the Nim API provided by this package, you can import its wrapper for Notcurses' raw C API and work with that directly, or use it to build an API to your liking

```nim
import notcurses/abi
# or: import notcurses/abi/core

var opts = notcurses_options()

let nc = notcurses_init(addr opts, stdout)
if nc.isNil: raise (ref Defect)(msg: "notcurses_init failed")

# or: let nc = notcurses_core_init(addr opts, stdout)
# or: if nc.isNil: raise (ref Defect)(msg: "notcurses_core_init failed")

if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "notcurses_stop failed")
```

#### Direct mode

```nim
import notcurses/abi/direct
# or: import notcurses/abi/direct/core

let flags = 0'u64

let ncd = ncdirect_init(nil, stdout, flags)
if ncd.isNil: raise (ref Defect)(msg: "ncdirect_init failed")

# or: let ncd = ncdirect_core_init(nil, stdout, flags)
# or: if ncd.isNil: raise (ref Defect)(msg: "ncdirect_core_init failed")

if ncdirect_stop(ncd) < 0: raise (ref Defect)(msg: "ncdirect_stop failed")
```

## Examples

See the modules in [`examples`](examples). To build and run the [`tui1`](examples/tui1.nim) example do

```text
$ nim c -r examples/tui1.nim
```

You can use additional compiler options, cf. [requirements](#requirements)

```text
$ nim c --passC:"-I${HOME}/repos/notcurses/include" \
        --passL:"-L${HOME}/repos/notcurses/build" \
        --passL:"-rpath ${HOME}/repos/notcurses/build" \
        -r examples/tui1.nim
```

To build all the examples do

```text
$ extras/build_examples.sh
```

Additional options are supported

```text
$ extras/build_examples.sh -d:release --passC ...
```

## Tests

Unit tests for nim-notcurses can be run with [`nimble`](https://github.com/nim-lang/nimble#readme)

```text
$ nimble test
```

You can use additional `nimble` and compiler options

```text
$ nimble --verbose test --passC ...
```

The test suites are rather thin at present but will be expanded eventually.

## Coverage

Coverage data is collected with [`lcov`](https://github.com/linux-test-project/lcov#readme) and uploaded to [codecov](https://codecov.io/gh/michaelsbradleyjr/nim-notcurses).

Most of Notcurses' facilities expect a proper terminal. Also, given the nature of the library, visual inspection of program output and interaction with it as it runs are the most practical means to ensure it's functioning as intended. For those reasons coverage runs are peformed locally, i.e. a CI pipeline isn't suitable.

Currently, most of the coverage data is generated by building and running the [examples](#examples), with unit [tests](#tests) filling in a few gaps

```text
$ extras/coverage.sh
```

Additional options are supported

```text
$ extras/coverage.sh --passC ...
```

Upload to codecov is not attempted if environment variable `CODECOV_TOKEN` is empty or not set.

:bulb: Quality of coverage data varies with the version of the Nim compiler, the newer the better. Also, owing to Nim's dead code elimination, which can't be disabled, coverage numbers can be misleading: a module may have many unmapped lines and still report `100%`. To get a true sense of the state of coverage, look at the reports for modules in [`notcurses/abi`](notcurses/abi): only lines pertaining to `proc` and `func` are generally of interest, and any that are not highlighted are not covered, i.e. those procedures are not being called via modules in [`notcurses/api`](notcurses/api).

## Requirements

[Notcurses](https://github.com/dankamongmen/notcurses#readme) needs to be installed with your package manager :package:, or you can compile it from source.

For example, on macOS, you could install it with [`brew`](https://brew.sh/)

```text
$ brew install notcurses
```

### BYO Notcurses 🍻

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

### Compiler options 👑

If you build Notcurses yourself and don't install it system-wide, then its headers and libraries will not be in locations known to your compiler and linker. In that case, use `--passC` and `--passL` with `nim c`.

For example, on macOS, if your own build of Notcurses is in `${HOME}/repos/notcurses/build`, you would use

```text
$ nim c --passC:"-I${HOME}/repos/notcurses/include" \
        --passL:"-L${HOME}/repos/notcurses/build" \
        --passL:"-rpath ${HOME}/repos/notcurses/build" \
        ...
```

On Linux and Windows, drop the `-rpath` option.

:bulb: Be careful to not have a system-wide installation of Notcurses while attempting to link against your own *non-installed* build of it, else you may experience mysterious difficulties 😵

### Windows

Support for Microsoft Windows is a bit anemic at present because [Windows Terminal](https://github.com/microsoft/terminal#readme) and Notcurses' support for it are works in progress.

All of the examples can be built and run on Windows + [MSYS2](https://www.msys2.org/), but
* Programs should be built in an MSYS2 shell and run in [Windows Terminal](https://github.com/microsoft/terminal#readme) in an MSYS2 shell. They can also be run in [Mintty](https://mintty.github.io/), but rendering problems will be more likely and more severe. It's easy to configure Windows Terminal to launch an MSYS2 shell, see [these instructions](https://www.msys2.org/docs/terminals/).
* DLLs for Notcurses must be in your MSYS2 shell's path at runtime, e.g.<br />`export PATH="${HOME}/repos/notcurses/build:${PATH}"`
* Windows' system locale needs to be set to [UTF-8](https://en.wikipedia.org/wiki/UTF-8):<br />*Language settings -> Administrative language settings -> Change system locale -> Beta: Use Unicode UTF-8 for worldwide language support*
* Expect to encounter rendering problems and for performance to be lackluster.

:bulb: Programs using nim-notcurses build correctly in GitHub Actions on Windows + MSYS2, but are known to *not* run successfully in that CI environment *if* they initialize Notcurses.

## Goals

* Provide a comprehensive wrapper for Notcurses' raw C API, and keep it up-to-date as Notcurses evolves.
* Offer a higher-level API built atop the lower-level wrapper, allowing Notcurses to be readily leveraged with the language features of Nim.

The high-level API is referred to as a *Nim API* elsewhere in this document and repository, for want of a better description.

In the future, it may be desirable to split this project into two packages: `notcurses` and `notcurses_abi`. The latter would be a dependency of the former. At present, it makes sense to develop the wrappers together as a single package.

**Non-goals:** provide an extensible widgets library, a text-based windowing system, or other advanced facilities that could be built with nim-notcurses. Such ideas can be explored in projects that have this package as a dependency.

## Versioning

nim-notcurses follows the [version number](https://github.com/dankamongmen/notcurses/releases) of Notcurses
* currently [`v3.0.9`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v3.0.9) (upstream: [`v3.0.9`](https://github.com/dankamongmen/notcurses/releases/tag/v3.0.9))
* beginning with [`v2.3.13`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v2.3.13) (upstream: [`v2.3.13`](https://github.com/dankamongmen/notcurses/releases/tag/v2.3.13)).

:bulb: It's recommended to only use versions `> 3.0.9` of *nim-notcurses* because its earlier versions were too raw and unproven.

:construction: At present, that means installing nim-notcurses per the latest commits on its [`master`](https://github.com/michaelsbradleyjr/nim-notcurses/tree/master) branch, cf. [installation](#installation). These instructions will be revised once changes in `master` are included in a tagged version.

Following [`v3.0.9`](https://github.com/michaelsbradleyjr/nim-notcurses/releases/tag/v3.0.9) the implementation of nim-notcurses was overhauled, with Notcurses' examples and demo ported to the Nim API and tested to compile and run correctly on various platforms.

## Stability

<!--
Notcurses' ABI is stable per major version, and this package's low-level wrapper is likewise stable as of version `>= 3.N.N`, cf. [versioning](#versioning).
-->

Notcurses' ABI is stable per major version, and this package's low-level wrapper will likewise be stable once changes in `master` are included in a tagged version, cf. [versioning](#versioning).

The Nim API (high-level wrapper) provided by this package is currently experimental. Until it is marked as stable, it may be subject to breaking changes across patch and minor versions.

## License

nim-notcurses is licensed and distributed under either of

* Apache License, Version 2.0: [LICENSE-APACHEv2](LICENSE-APACHEv2) or [https://opensource.org/licenses/Apache-2.0](https://opensource.org/licenses/Apache-2.0)
* MIT License: [LICENSE-MIT](LICENSE-MIT) or [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)

at your option. The contents of this repository may not be copied, modified, or distributed except according to those terms.

### Dependency license

Notcurses is [licensed](https://github.com/dankamongmen/notcurses/blob/v3.0.9/COPYRIGHT) under the Apache License, Version 2.0: [LICENSE-NOTCURSES](LICENSE-NOTCURSES).
