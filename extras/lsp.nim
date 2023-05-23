{.warning: "This module is not intended for compilation!".}

# this is a support module for nimlangserver so that a minimal spawning of
# nimsuggest processes can service all modules in nim-notcurses; see
# ./project-mapping.el and ../.vscode/settings.json

import
  examples/abi/cjkscroll as abi_cjkscroll,
  examples/abi/cli1 as abi_cli1,
  examples/abi/cli2 as abi_cli2,
  examples/abi/direct1 as abi_direct1,
  examples/abi/direct_sgr as abi_direct_sgr,
  examples/abi/gradients as abi_gradients,
  examples/abi/multiselect as abi_multiselect,
  examples/abi/tui1 as abi_tui1,
  examples/abi/zalgo as abi_zalgo,
  examples/cjkscroll,
  examples/cli1,
  examples/cli2,
  examples/direct1,
  examples/direct_sgr,
  examples/gradients,
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
