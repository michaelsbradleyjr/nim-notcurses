const
  notcursesDownload {.booldefine.} = true
  notcursesHeaderRelPath {.strdefine.} =
    # see: https://github.com/nimterop/nimterop/issues/285
    when defined(windows):
      "include\\\\notcurses\\\\direct.h"
    else:
      "include" / "notcurses" / "direct.h"

when notcursesDownload or isDefined(notcursesDl): setDefines(@["directDL"])
when isDefined(notcursesStatic): setDefines(@["directStatic"])
when isDefined(notcursesStd): setDefines(@["directStd"])
