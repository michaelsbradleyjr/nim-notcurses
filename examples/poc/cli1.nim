import notcurses/cli
# or: import notcurses/cli/core

let nc = Nc.init NcOptions.init DrainInput

Nc.addExitProc

nc.render.expect
