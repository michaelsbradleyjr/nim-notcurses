{.passL: "-lnotcurses -lnotcurses-core".}

{.push raises: [].}

import ./abi/direct/impl as abi_impl
import ./api/direct/impl

export impl

proc init*(T: typedesc[NotcursesDirect], options = Options.init,
    file = stdout): T =
  T.init(ncdirect_init, options, file)
