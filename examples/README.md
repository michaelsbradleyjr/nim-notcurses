# Examples

Nim modules in this directory were closely derived from sources in [Notcurses](https://github.com/dankamongmen/notcurses#readme) [`v3.0.9`](https://github.com/dankamongmen/notcurses/tree/v3.0.9) and should be considered subject to the terms and conditions of its [license](https://github.com/dankamongmen/notcurses/blob/v3.0.9/COPYRIGHT).

## Motivation

Translating Notcurses' examples was not an end in itself; the process was iterative and the goal was to inform the high-level API of nim-notcurses
1. wrap portions of Notcurses' raw C API so an upstream example could be ported from C to Nim
2. implement portions of a higher-level API
3. refactor ported example using the high-level API
4. goto 1

## Summary

*Differences*, if any, reflect how a `.nim` example behaves compared to its `.c` counterpart

| Nim                                      | C                    | Differences                                        |
| ---------------------------------------- | -------------------- | -------------------------------------------------- |
| [`cjkscroll.nim`](cjkscroll.nim)         | [`cjkscroll.c`][1]   | renders per character instead of per line, q quits |
| [`cli1.nim`](cli1.nim)                   | [`cli2.c`][2]        | renders *"Hello..."*                               |
| [`cli2.nim`](cli2.nim)                   | [`cli1.c`][3]        | reports inputs                                     |
| [`direct1.nim`](direct1.nim)             | `n/a`                |                                                    |
| [`direct_sgr.nim`](direct_sgr.nim)       | [`sgr-direct.c`][4]  |                                                    |
| [`gradients.nim`](gradients.nim)         | [`gradients.c`][5]   |                                                    |
| [`multiselect.nim`](abi/multiselect.nim) | [`multiselect.c`][6] |                                                    |
| [`tui1.nim`](tui1.nim)                   | [`cli3.c`][7]        | renders *"Hello..."*, q quits                      |
| [`zalgo.nim`](zalgo.nim)                 | [`zalgo.c`][8]       |                                                    |

[1]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/cjkscroll.c
[2]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/cli2.c
[3]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/cli1.c
[4]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/sgr-direct.c
[5]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/gradients.c
[6]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/multiselect.c
[7]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/cli3.c
[8]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/zalgo.c

### examples/abi

Modules in [`examples/abi`](abi) demonstrate working with the wrapper for the raw C API instead of the high-level API. They match the behavior of their counterparts in their parent directory and, naturally, that involves borrowing some code from the internals of the high-level API or otherwise providing for equivalent behavior. For example, see [`examples/abi/cli2.nim`](abi/cli2.nim).

Boilerplate code is intentionally not captured in a helper module because doing so is beside the point. C-style invocation is used for Notcurses' facilities because it looks more natural, e.g. `ncplane_putstr(stdn, s)` vs. `stdn.ncplane_putstr(s)`.

## Notcurses license

```text
Copyright 2019-2022 Nick Black
Copyright 2019-2021 Marek Habersack
Copyright 2020-2021 José Luis Cruz
Copyright 2020-2021 igo95862
Copyright 2021 Łukasz Drukała

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

The contents of src/fetch/ncart.c are extracted from Neofetch,
copyright 2015-2021 Dylan Araps under the MIT License:

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in al
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
