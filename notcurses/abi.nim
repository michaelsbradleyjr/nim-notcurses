when defined(macosx):
  {.passL: "-lnotcurses.3 -lnotcurses-core.3".}
else:
  {.passL: "-l:libnotcurses.so.3 -l:libnotcurses-core.so.3".}

const NotcursesImportPrefix = "notcurses_"

const NotcursesLib =
  when defined(macosx):
    "libnotcurses.3.dylib"
  else:
    "libnotcurses.so.3"

include ./abi/private
include ./abi/private/exports
