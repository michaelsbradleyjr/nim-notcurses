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
  notcurses/abi/direct/core as abi_ncd_core,
  notcurses/core as nc_core,
  notcurses/direct as ncd,
  notcurses/direct/core as ncd_core,
  notcurses/locale,
  tests/test_all

{.warning[UnusedImport]: off.}
