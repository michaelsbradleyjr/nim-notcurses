import pkg/notcurses/abi
# or: import pkg/notcurses/abi/core

let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT
var opts = notcurses_options(flags: flags)

let nc = notcurses_init(addr opts, stdout)
if nc.isNil: raise (ref Defect)(msg: "notcurses_init failed")

# or: let nc = notcurses_core_init(addr opts, stdout)
# or: if nc.isNil: raise (ref Defect)(msg: "notcurses_core_init failed")

let stdn = notcurses_stdplane nc
discard ncplane_putstr(stdn, "Hello, Notcurses!\n")

if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "notcurses_stop failed")
