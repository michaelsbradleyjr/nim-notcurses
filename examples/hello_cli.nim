import std/bitops
import notcurses/core

let
  flags = bitor(NCOPTION_CLI_MODE, NCOPTION_DRAIN_INPUT)
  opts = notcurses_options(flags: flags)
  nc = notcurses_core_init(unsafeAddr opts, stdout)
  stdn = nc.notcurses_stdplane

discard stdn.ncplane_putstr "Hello\n".cstring

discard nc.notcurses_render

discard nc.notcurses_stop
