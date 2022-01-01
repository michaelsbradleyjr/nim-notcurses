import notcurses

let
  opts = [DrainInput, NoAlternateScreen, NoClearBitmaps, PreserveCursor]
  nc = Nc.init NcOpts.init opts

nc.render.expect
nc.stop.expect
