when defined(macosx):
  {.passL: "-lnotcurses-core.3".}
elif defined(windows):
  {.passL: "-lnotcurses-core".}
else:
  {.passL: "-l:libnotcurses-core.so.3".}

const
  notcurses_init_import_prefix = "notcurses_core_"
  notcurses_lib =
    when defined(macosx):
      "libnotcurses-core.3.dylib"
    elif defined(windows):
      "libnotcurses-core.dll"
    else:
      "libnotcurses-core.so.3"

include ./private/constants
include ./private
include ./private/exports
