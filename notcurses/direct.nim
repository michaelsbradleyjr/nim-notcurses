{.passL: "-lnotcurses -lnotcurses-core".}

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import ./abi/direct/impl as abi_impl
import ./api/direct/impl

export impl

proc init*(T: type NotcursesDirect, options = Options.init, file = stdout,
    addExitProc = true): T =
  T.init(ncdirect_init, options, file, addExitProc)
