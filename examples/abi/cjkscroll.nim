import std/os
import pkg/notcurses/abi
# or: import pkg/notcurses/abi/core
import pkg/notcurses/abi/locale

if setlocale(LC_ALL, "").isNil: raise (ref Defect)(msg: "setlocale failed")

let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT or
  NCOPTION_INHIBIT_SETLOCALE
var opts = notcurses_options(flags: flags)

let nc = notcurses_init(addr opts, stdout)
if nc.isNil: raise (ref Defect)(msg: "notcurses_init failed")

# or: let nc = notcurses_core_init(addr opts, stdout)
# or: if nc.isNil: raise (ref Defect)(msg: "notcurses_core_init failed")

let stdn = notcurses_stdplane nc

const notice = "\nThis program is *not* indicative of real scrolling speed\n\n"

ncplane_set_styles(stdn, NCSTYLE_BOLD)
discard ncplane_putstr(stdn, notice)
ncplane_set_styles(stdn, NCSTYLE_NONE)

const
  first = 0x4e00'u16
  last  = 0x9fff'u16

var u = first
while true:
  discard ncplane_putwc(stdn, u.wchar)
  discard notcurses_render nc
  if u < last: inc u
  else: u = first
  sleep 10

if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "notcurses_stop failed")
