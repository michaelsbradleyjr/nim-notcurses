{.passL: "-lnotcurses-core".}

{.push raises: [].}

import ./abi/impl as abi_impl
import ./api/impl

export impl

proc init*(T: typedesc[Notcurses], options = Options.init, file = stdout): T =
  T.init(notcurses_core_init, options, file)
