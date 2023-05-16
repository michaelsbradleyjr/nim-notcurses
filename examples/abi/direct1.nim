import pkg/notcurses/abi/direct
# or: import pkg/notcurses/abi/direct/core

let flags = NCDIRECT_OPTION_DRAIN_INPUT

let ncd = ncdirect_init(nil, stdout, flags)
if ncd.isNil: raise (ref Defect)(msg: "ncdirect_init failed")

# or: let ncd = ncdirect_core_init(nil, stdout, flags)
# or: if ncd.isNil: raise (ref Defect)(msg: "ncdirect_core_init failed")

discard ncdirect_putstr(ncd, 0, "Hello, Direct mode!\n")

if ncdirect_stop(ncd) < 0: raise (ref Defect)(msg: "ncdirect_stop failed")
