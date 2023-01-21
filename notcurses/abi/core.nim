import ./version

const
  NcStatic {.booldefine.}: bool = false
  nc_init_prefix = "notcurses_core_"

when not NcStatic:
  const
    nc_init_lib =
      when defined(macosx):
        "libnotcurses-core.3.dylib"
      elif defined(windows):
        "libnotcurses-core.dll"
      else:
        "libnotcurses-core.so.3"

    nc_lib =
      when defined(macosx):
        "libnotcurses-ffi.3.dylib"
      elif defined(windows):
        "libnotcurses-ffi.dll"
      else:
        "libnotcurses-ffi.so.3"

include ./private
