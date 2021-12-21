const
  notcursesDownload {.booldefine.} = true
  notcursesHeaderRelPath {.strdefine.} =
    # see: https://github.com/nimterop/nimterop/issues/285
    when defined(windows):
      "include\\\\notcurses\\\\notcurses.h"
    else:
      "include" / "notcurses" / "notcurses.h"

when notcursesDownload: setDefines(@["notcursesDL"])
