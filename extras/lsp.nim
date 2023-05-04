{.warning: "This module is not intended for compilation!".}

# this is a support module for nimlangserver so that a minimal spawning of
# nimsuggest processes can service all modules in nim-notcurses; see
# ./project-mapping.el and ../.vscode/settings.json

import
  examples/cjkscroll,
  examples/cli1,
  examples/cli2,
  examples/direct1,
  examples/direct_sgr,
  examples/gradients,
  examples/multiselect,
  examples/tui1,
  examples/zalgo,
  notcurses,
  notcurses/abi,
  notcurses/abi/core,
  notcurses/abi/direct,
  notcurses/abi/direct/core as notcurses_abi_direct_core,
  notcurses/core as notcurses_core,
  notcurses/direct as notcurses_direct,
  notcurses/direct/core as notcurses_direct_core,
  tests/test_all

{.warning[UnusedImport]: off.}
