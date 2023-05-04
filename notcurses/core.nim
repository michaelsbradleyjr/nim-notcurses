{.passL: "-lnotcurses-core".}

when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import ./abi/impl as abi_impl
import ./api/impl

export impl

proc init*(T: type Notcurses, options = Options.init, file = stdout,
    addExitProc = true): T =
  T.init(notcurses_core_init, options, file, addExitProc)
