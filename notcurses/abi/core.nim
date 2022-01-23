const
  nc_init_lib =
    when defined(macosx):
      "libnotcurses-core.3.dylib"
    elif defined(windows):
      "libnotcurses-core.dll"
    else:
      "libnotcurses-core.so.3"

  nc_init_prefix = "notcurses_core_"

  nc_lib =
    when defined(macosx):
      "libnotcurses-ffi.3.dylib"
    elif defined(windows):
      "libnotcurses-ffi.dll"
    else:
      "libnotcurses-ffi.so.3"

include ./private/common
include ./private/constants
include ./private
include ./private/exports
