{.passL: "-lnotcurses -lnotcurses-core".}

when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import ./abi/direct/impl as abi_impl
import ./api/direct/impl

export impl

proc init*(T: type NotcursesDirect, options = Options.init, file = stdout): T =
  T.init(ncdirect_init, options, file)
