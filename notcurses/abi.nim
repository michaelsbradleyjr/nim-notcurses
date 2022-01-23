const
  nc_init_lib =
    when defined(macosx):
      "libnotcurses.3.dylib"
    elif defined(windows):
      "libnotcurses.dll"
    else:
      "libnotcurses.so.3"

  nc_init_prefix = "notcurses_"

  nc_lib =
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
