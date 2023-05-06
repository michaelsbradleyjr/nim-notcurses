{.passL: "-lnotcurses -lnotcurses-core".}

when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import ./notcurses/abi/impl as abi_impl
import ./notcurses/api/impl

export impl

proc init*(T: typedesc[Notcurses], options = Options.init, file = stdout): T =
  T.init(notcurses_init, options, file)
