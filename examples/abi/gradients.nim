import std/os
import pkg/notcurses/abi/core
# or: import pkg/notcurses/abi

var opts = notcurses_options(flags: NCOPTION_DRAIN_INPUT)

let nc = notcurses_core_init(addr opts, stdout)
if nc.isNil: raise (ref Defect)(msg: "notcurses_core_init failed")

# or: let nc = notcurses_init(addr opts, stdout)
# or: if nc.isNil: raise (ref Defect)(msg: "notcurses_init failed")

let stdn = notcurses_stdplane nc

const
  NCSTYLE_NONE = NCSTYLE_NONE.uint16

  ul = NCCHANNELS_INITIALIZER(0x00, 0x00, 0x00, 0xff, 0xff, 0xff)
  ur = NCCHANNELS_INITIALIZER(0x00, 0xff, 0xff, 0xff, 0x00, 0x00)
  ll = NCCHANNELS_INITIALIZER(0xff, 0x00, 0x00, 0x00, 0xff, 0xff)
  lr = NCCHANNELS_INITIALIZER(0xff, 0xff, 0xff, 0x00, 0x00, 0x00)

proc gradA() =
  discard ncplane_gradient(stdn, 0, 0, 0, 0, "A", NCSTYLE_NONE, ul, ur, ll, lr)
  discard notcurses_render nc
  sleep 1000

proc gradStriations() =
  discard ncplane_gradient(stdn, 0, 0, 0, 0, "▄", NCSTYLE_NONE, ul, ur, ll, lr)
  discard notcurses_render nc
  sleep 1000
  discard ncplane_gradient(stdn, 0, 0, 0, 0, "▀", NCSTYLE_NONE, ul, ur, ll, lr)
  discard notcurses_render nc
  sleep 1000

proc gradHigh() =
  let
    ul = NCCHANNEL_INITIALIZER(0x00, 0x00, 0x00)
    ur = NCCHANNEL_INITIALIZER(0x00, 0xff, 0xff)
    ll = NCCHANNEL_INITIALIZER(0xff, 0x00, 0x00)
    lr = NCCHANNEL_INITIALIZER(0xff, 0xff, 0xff)
  discard ncplane_gradient2x1(stdn, 0, 0, 0, 0, ul, ur, ll, lr)
  discard notcurses_render nc
  sleep 1000

gradA()
gradStriations()
gradHigh()

if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "notcurses_stop failed")
