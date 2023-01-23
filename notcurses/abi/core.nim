const
  NcStatic {.booldefine.}: bool = false
  nc_init_prefix = "notcurses_core_"

when not NcStatic:
  const
    nc_init_lib =
      when defined(macosx):
        "libnotcurses-core.dylib"
      elif defined(windows):
        "libnotcurses-core.dll"
      else:
        "libnotcurses-core.so"

    nc_lib =
      when defined(macosx):
        "libnotcurses-ffi.dylib"
      elif defined(windows):
        "libnotcurses-ffi.dll"
      else:
        "libnotcurses-ffi.so"

include ./impl
