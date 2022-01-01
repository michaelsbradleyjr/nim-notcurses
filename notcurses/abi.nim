{.passL: "-lnotcurses.3 -lnotcurses-core.3".}

include ./abi/common

const NotcursesImportPrefix = "notcurses_"

const NotcursesLib =
  when defined(macosx):
    "libnotcurses.3.dylib"
  else:
    "libnotcurses.3.so"

include ./abi/private
include ./abi/private/exports
