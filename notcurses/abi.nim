const
  NcStatic {.booldefine.}: bool = false
  nc_init_prefix = "notcurses_"

when not NcStatic:
  const
    nc_init_lib =
      when defined(macosx):
        "libnotcurses.dylib"
      elif defined(windows):
        "libnotcurses.dll"
      else:
        "libnotcurses.so"

    nc_lib =
      when defined(macosx):
        "libnotcurses-ffi.dylib"
      elif defined(windows):
        "libnotcurses-ffi.dll"
      else:
        "libnotcurses-ffi.so"

include ./abi/impl
