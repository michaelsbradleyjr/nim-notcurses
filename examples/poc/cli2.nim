import std/exitprocs

import notcurses

let
  opts = [DrainInput, NoAlternateScreen, NoClearBitmaps, PreserveCursor]
  nc = Nc.init NcOpts.init opts

addExitProc stopNc
nc.render.expect
