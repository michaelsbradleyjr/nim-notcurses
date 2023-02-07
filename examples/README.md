# Examples

Nim modules in this directory were closely derived from sources in [Notcurses `v3.0.9`](https://github.com/dankamongmen/notcurses/tree/v3.0.9) and should therefore be considered subject to the terms and conditions of its [license](https://github.com/dankamongmen/notcurses/blob/v3.0.9/COPYRIGHT).

## Motivation

Translating Notcurses' example C sources was not an end in itself; instead, the goal was twofold and the process was iterative:
* Wrap Notcurses' raw C API to an extent that one/more upstream examples could be ported from `.c` to `.nim`.
* Allow that experience to inform the design of a higher-level *Nim API* built atop the lower-level wrapper.

Rather than rework texts embedded in the upstream examples to make these `.nim` modules unique, this author preferred to leave them unmodified: they are illustrations of lessons the original author desired to teach.

## Summary

Differences reflect how a `.nim` example behaves differently from its `.c` counterpart.

| Nim                                  | C                            |  Differences                              |
| ------------------------------------ | ---------------------------- | ----------------------------------------- |
| [`cjkscroll.nim`](cjkscroll.nim)     | [`src/poc/cjkscroll.c`][1]   | renders per character instead of per line |
| [`cli1.nim`](cli1.nim)               | [`src/poc/cli2.c`][2]        | renders *"Hello..."*                      |
| [`cli2.nim`](cli2.nim)               | [`src/poc/cli1.c`][3]        | reports inputs                            |
| [`direct1.nim`](direct1.nim)         | n/a                          |                                           |
| [`direct_sgr.nim`](direct_sgr.nim)   | [`src/poc/sgr-direct.c`][4]  |                                           |
| [`gradients.nim`](gradients.nim)     | [`src/poc/gradients.c`][5]   |                                           |
| [`multiselect.nim`](multiselect.nim) | [`src/poc/multiselect.c`][6] |                                           |
| [`tui1.nim`](tui1.nim)               | [`src/poc/cli3.c`][7]        | renders *"Hello..."*                      |
| [`zalgo.nim`](zalgo.nim)             | [`src/poc/zalgo.c`][8]       |                                           |

[1]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/cjkscroll.c
[2]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/cli2.c
[3]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/cli1.c
[4]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/sgr-direct.c
[5]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/gradients.c
[6]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/multiselect.c
[7]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/cli3.c
[8]: https://github.com/dankamongmen/notcurses/blob/v3.0.9/src/poc/zalgo.c

## Upstream license

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
