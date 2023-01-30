const
  ncCore = true
  ncStatic {.booldefine.}: bool = false

when not ncStatic:
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
# else:
# look into using e.g. `{.passC/L: staticExec("pkg-config ...") .}`, but
# consider Notcurses has a complex set of dependencies relative to
# `import notcurses/-cli|direct/-core`, OS, and options passed to cmake

include ./constants
include ./impl
