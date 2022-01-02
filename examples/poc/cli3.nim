import notcurses
# or: import notcurses/core

let
  opts = [DrainInput, NoClearBitmaps, PreserveCursor]
  nc = Nc.init NcOpts.init opts

addNcExitProc()

nc.render.expect
