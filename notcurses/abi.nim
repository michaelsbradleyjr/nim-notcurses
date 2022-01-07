when defined(macosx):
  {.passL: "-lnotcurses.3 -lnotcurses-core.3".}
elif defined(windows):
  {.passL: "-lnotcurses -lnotcurses-core".}
else:
  {.passL: "-l:libnotcurses.so.3 -l:libnotcurses-core.so.3".}

const
  notcurses_init_import_prefix = "notcurses_"
  notcurses_lib =
    when defined(macosx):
      "libnotcurses.3.dylib"
    elif defined(windows):
      "libnotcurses.dll"
    else:
      "libnotcurses.so.3"

include ./abi/private/constants
include ./abi/private
include ./abi/private/exports
