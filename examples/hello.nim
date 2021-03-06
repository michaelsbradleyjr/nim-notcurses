import std/os
import notcurses/core

let
  opts = notcurses_options(flags: NCOPTION_DRAIN_INPUT)
  nc = notcurses_core_init(unsafeAddr opts, stdout)
  stdn = nc.notcurses_stdplane

discard stdn.ncplane_putstr "Hello\n".cstring

discard nc.notcurses_render

sleep 3000

discard nc.notcurses_stop
