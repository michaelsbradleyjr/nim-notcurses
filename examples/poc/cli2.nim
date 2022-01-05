import notcurses
# or: import notcurses/core

let
  opts = [DrainInput, NoAlternateScreen, NoClearBitmaps, PreserveCursor]
  nc = Nc.init NcOpts.init opts

Nc.addExitProc

nc.render.expect
