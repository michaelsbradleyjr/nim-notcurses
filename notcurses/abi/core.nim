{.passL: "-lnotcurses-core.3".}

import ./common

const NotcursesImportPrefix = "notcurses_core_"

const NotcursesLib =
  when defined(macosx):
    "libnotcurses-core.3.dylib"
  else:
    "libnotcurses-core.3.so"

include ./private/abi
include ./private/constants
include ./private/exports
