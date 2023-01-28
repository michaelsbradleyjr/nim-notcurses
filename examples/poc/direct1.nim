import notcurses/direct
# or: import notcurses/direct/core

# uncomment api calls when api layer supports Direct mode
# let nc = Nc.init NcOptions.init DrainInput

# delete all below when api layer supports Direct mode
import notcurses/abi
# or: import notcurses/abi/core
# import notcurses/abi/core

let nc = ncdirect_init(nil, stdout, 0)
# let nc = ncdirect_core_init(nil, stdout, 0)

discard ncdirect_stop(nc)
