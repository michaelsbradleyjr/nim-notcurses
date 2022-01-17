const
  notcurses_init_lib =
    when defined(macosx):
      "libnotcurses.3.dylib"
    elif defined(windows):
      "libnotcurses.dll"
    else:
      "libnotcurses.so.3"

  notcurses_init_prefix = "notcurses_"

  notcurses_lib =
    when defined(macosx):
      "libnotcurses-ffi.3.dylib"
    elif defined(windows):
      "libnotcurses-ffi.dll"
    else:
      "libnotcurses-ffi.so.3"

include ./abi/private/common
include ./abi/private/constants
include ./abi/private
include ./abi/private/exports
