const
  notcursesDownload {.booldefine.} = true
  notcursesHeaderRelPath {.strdefine.} = "include" / "notcurses" / "direct.h"

when notcursesDownload or isDefined(notcursesDl): setDefines(@["directDL"])
when isDefined(notcursesStatic): setDefines(@["directStatic"])
when isDefined(notcursesStd): setDefines(@["directStd"])
