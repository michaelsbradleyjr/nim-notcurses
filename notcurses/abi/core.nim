when defined(macosx):
  {.passL: "-lnotcurses-core.3".}
else:
  {.passL: "-l:libnotcurses-core.so.3".}

const NotcursesImportPrefix = "notcurses_core_"

const NotcursesLib =
  when defined(macosx):
    "libnotcurses-core.3.dylib"
  else:
    "libnotcurses-core.so.3"

include ./private
include ./private/exports
