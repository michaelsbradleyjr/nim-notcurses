{.passL: "-lnotcurses.3 -lnotcurses-core.3".}

import ./abi/common

const NotcursesImportPrefix = "notcurses_"

const NotcursesLib =
  when defined(macosx):
    "libnotcurses.3.dylib"
  else:
    "libnotcurses.3.so"

include ./abi/private/abi
include ./abi/private/constants
include ./abi/private/exports