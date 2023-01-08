import notcurses/cli
# or: import notcurses/core/cli

let nc = Nc.init NcOptions.init DrainInput

Nc.addExitProc

nc.render.expect
