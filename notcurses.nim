{.passL: "-lnotcurses -lnotcurses-core".}

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import ./notcurses/abi/impl as abi_impl
import ./notcurses/api/impl

export impl

proc init*(T: type Notcurses, options = Options.init, file = stdout,
    addExitProc = true): T =
  T.init(notcurses_init, options, file, addExitProc)
