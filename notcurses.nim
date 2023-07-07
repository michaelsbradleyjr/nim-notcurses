{.passL: "-lnotcurses -lnotcurses-core".}

{.push raises: [].}

import ./notcurses/abi/impl as abi_impl
import ./notcurses/api/impl

export impl

proc init*(T: typedesc[Notcurses], options = Options.init, file = stdout): T =
  T.init(notcurses_init, options, file)
