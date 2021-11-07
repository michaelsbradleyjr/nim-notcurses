const
  notcursesDownload {.booldefine.} = true
  notcursesHeaderRelPath {.strdefine.} = "include" / "notcurses" / "notcurses.h"

when notcursesDownload: setDefines(@["notcursesDL"])
