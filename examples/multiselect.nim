# refactor when nim-notcurses high-level api supports ncmselector

import std/os
import pkg/notcurses/abi

# `ncvisual_from_file` makes use of Notcurses' multimedia stack so can't
# `import pkg/notcurses/abi/core` if this example is to function fully

var opts = notcurses_options(loglevel: NCLOGLEVEL_ERROR)
let nc = notcurses_init(addr opts, stdout)
if isNil nc: raise (ref Defect)(msg: "notcurses_init failed")
let stdn = notcurses_stdplane nc

discard notcurses_mice_enable(nc, NCMICE_BUTTON_EVENT)
# selection with mouse in `multiselect` is not working
# https://github.com/dankamongmen/notcurses/issues/2699

proc stopAndRaise(msg: string) =
  if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "notcurses_stop failed")
  raise (ref Defect)(msg: msg)

if notcurses_canopen_images nc:
  let
    path = joinPath(currentSourcePath.parentDir, "data/covid19.jpg")
    ncv = ncvisual_from_file path.cstring
  if isNil ncv: stopAndRaise "ncvisual_from_file failed"
  var vopts = ncvisual_options(n: stdn, scaling: NCSCALE_STRETCH)
  if isNil ncvisual_blit(nc, ncv, addr vopts):
    stopAndRaise "ncvisual_blit failed"

discard ncplane_set_fg_rgb(stdn, 0x40f040)
discard ncplane_putstr_aligned(stdn, 0, NCALIGN_RIGHT,
  "multiselect widget demo")

type msi = ncmselector_item

var items = [
  msi(option: "Pa231", desc: "Protactinium-231 (162kg)", selected: false),
  msi(option: "U233",  desc: "Uranium-233 (15kg)",       selected: false),
  msi(option: "U235",  desc: "Uranium-235 (50kg)",       selected: false),
  msi(option: "Np236", desc: "Neptunium-236 (7kg)",      selected: false),
  msi(option: "Np237", desc: "Neptunium-237 (60kg)",     selected: false),
  msi(option: "Pu238", desc: "Plutonium-238 (10kg)",     selected: false),
  msi(option: "Pu239", desc: "Plutonium-239 (10kg)",     selected: false),
  msi(option: "Pu240", desc: "Plutonium-240 (40kg)",     selected: false),
  msi(option: "Pu241", desc: "Plutonium-241 (13kg)",     selected: false),
  msi(option: "Am241", desc: "Americium-241 (100kg)",    selected: false),
  msi(option: "Pu242", desc: "Plutonium-242 (100kg)",    selected: false),
  msi(option: "Am242", desc: "Americium-242 (18kg)",     selected: false),
  msi(option: "Am243", desc: "Americium-243 (155kg)",    selected: false),
  msi(option: "Cm243", desc: "Curium-243 (10kg)",        selected: false),
  msi(option: "Cm244", desc: "Curium-244 (30kg)",        selected: false),
  msi(option: "Cm245", desc: "Curium-245 (13kg)",        selected: false),
  msi(option: "Cm246", desc: "Curium-246 (84kg)",        selected: false),
  msi(option: "Cm247", desc: "Curium-247 (7kg)",         selected: false),
  msi(option: "Bk247", desc: "Berkelium-247 (10kg)",     selected: false),
  msi(option: "Cf249", desc: "Californium-249 (6kg)",    selected: false),
  msi(option: "Cf251", desc: "Californium-251 (9kg)",    selected: false),
  msi(option: nil,     desc: nil,                        selected: false)
]

proc run_mselect(ns: ptr ncmultiselector) =
  discard notcurses_render nc
  var ni = ncinput()
  while true:
    let keypress = notcurses_get_blocking(nc, addr ni)
    if keypress == high(uint32): break
    if ni.evtype == NCTYPE_RELEASE: continue
    if not ncmultiselector_offer_input(ns, addr ni):
      case keypress:
        of NCKEY_ENTER, 'q'.uint32: break
        of 'M'.uint32, 'J'.uint32:
          if ncinput_ctrl_p(addr ni): break
        else: continue
    else: discard notcurses_render nc
  ncmultiselector_destroy(ns)

var sopts = ncmultiselector_options(
  items        : cast[ptr UncheckedArray[ncmselector_item]](addr items),
  maxdisplay   : 10,
  opchannels   : NCCHANNELS_INITIALIZER(0xe0, 0x80, 0x40, 0x00, 0x00, 0x00),
  descchannels : NCCHANNELS_INITIALIZER(0x80, 0xe0, 0x40, 0x00, 0x00, 0x00),
  titlechannels: NCCHANNELS_INITIALIZER(0x20, 0xff, 0xff, 0x00, 0x00, 0x20),
  footchannels : NCCHANNELS_INITIALIZER(0xe0, 0x00, 0x40, 0x20, 0x20, 0x00),
  boxchannels  : NCCHANNELS_INITIALIZER(0x20, 0xe0, 0xe0, 0x20, 0x00, 0x00)
)

var bgchannels = NCCHANNELS_INITIALIZER(0x00, 0x20, 0x00, 0x00, 0x20, 0x00)
discard ncchannels_set_fg_alpha(addr bgchannels, NCALPHA_BLEND.cuint)
discard ncchannels_set_bg_alpha(addr bgchannels, NCALPHA_BLEND.cuint)

var
  item = 0
  nopts = ncplane_options(y: 3, x: 0, rows: 1, cols: 1)

template run(body: untyped): untyped =
  body
  let mseln = ncplane_create(stdn, addr nopts)
  if isNil mseln: stopAndRaise "ncplane_create failed"
  discard ncplane_set_base(mseln, "", 0, bgchannels)
  let ns = ncmultiselector_create(mseln, addr sopts)
  inc item
  if isNil ns:
    stopAndRaise "ncmultiselector_create failed to create selector " & $item
  run_mselect ns

run:
  sopts.title     = "this is truly an awfully long example of a " &
                    "MULTISELECTOR title"
  sopts.secondary = "pick one (you will die regardless)"
  sopts.footer    = "press q to exit (there is sartrev(\"no exit\"))"

run:
  sopts.title     = "short round title"

run:
  sopts.title     = "short round title"
  sopts.secondary = "now this secondary is also very, very, very " &
                    "outlandishly long, you see"

run:
  sopts.title     = "the whole world is watching"
  sopts.secondary = nil
  sopts.footer    = "now this FOOTERFOOTER is also very, very, very " &
                    "outlandishly long, you see"

run:
  sopts.title     = "chomps"
  sopts.secondary = nil
  sopts.footer    = nil

if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "notcurses_stop failed")
