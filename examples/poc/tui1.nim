import std/os
import notcurses
# or: import notcurses/core

let nc = Nc.init NcOptions.init DrainInput

Nc.addExitProc

sleep 3000
