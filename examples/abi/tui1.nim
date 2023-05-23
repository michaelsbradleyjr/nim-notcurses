import pkg/notcurses/abi
# or: import pkg/notcurses/abi/core

var opts = notcurses_options()

let nc = notcurses_init(addr opts, stdout)
if nc.isNil: raise (ref Defect)(msg: "notcurses_init failed")

# or: let nc = notcurses_core_init(addr opts, stdout)
# or: if nc.isNil: raise (ref Defect)(msg: "notcurses_core_init failed")

let stdn = notcurses_stdplane nc
discard ncplane_putstr(stdn, "Hello, Notcurses!")
discard ncplane_putstr_yx(stdn, 2, 0, "press q to quit")
discard notcurses_render nc

while notcurses_get_blocking(nc, nil) != 'q'.uint32: discard

if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "notcurses_stop failed")
