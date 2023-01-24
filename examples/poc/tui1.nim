import std/os
import notcurses
# or: import notcurses/core

let nc = Nc.init NcOptions.init DrainInput

nc.render.expect
sleep 3000
