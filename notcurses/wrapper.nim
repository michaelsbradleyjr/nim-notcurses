{.passL: "-lnotcurses.3 -lnotcurses-core.3".}

import ./wrapper/common

const NotcursesImportPrefix = "notcurses_"

const NotcursesLib =
  when defined(macosx):
    "libnotcurses.3.dylib"
  else:
    "libnotcurses.3.so"

include ./wrapper/private/wrapper
include ./wrapper/private/exports
