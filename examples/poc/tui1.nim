import notcurses
# or: import notcurses/core

let
  opts = [DrainInput, NoClearBitmaps, PreserveCursor]
  nc = Nc.init NcOptions.init opts

Nc.addExitProc

nc.render.expect
