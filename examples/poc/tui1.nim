import notcurses
# or: import notcurses/core

let nc = Nc.init NcOptions.init DrainInput

Nc.addExitProc

nc.render.expect
