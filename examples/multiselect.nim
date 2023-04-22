# refactor when nim-notcurses high-level api supports ncmselector

import std/os
import pkg/stew/byteutils
import notcurses/abi

# `ncvisual_from_file` makes use of Notcurses' multimedia stack so can't
# `import notcurses/abi/core` if this example is to function fully

proc nop() {.noconv.} = discard
setControlCHook(nop)

let loglevel = NCLOGLEVEL_ERROR
var opts = notcurses_options(loglevel: loglevel)
let nc = notcurses_init(addr opts, stdout)
if isNil nc: raise (ref Defect)(msg: "Notcurses failed to initialize")
discard notcurses_mice_enable(nc, NCMICE_BUTTON_EVENT)

# selection with mouse in `multiselect` is not working
# https://github.com/dankamongmen/notcurses/issues/2699

var items = [
  ncmselector_item(option: "Pa231", desc: "Protactinium-231 (162kg)", selected: false),
  ncmselector_item(option: "U233",  desc: "Uranium-233 (15kg)",       selected: false),
  ncmselector_item(option: "U235",  desc: "Uranium-235 (50kg)",       selected: false),
  ncmselector_item(option: "Np236", desc: "Neptunium-236 (7kg)",      selected: false),
  ncmselector_item(option: "Np237", desc: "Neptunium-237 (60kg)",     selected: false),
  ncmselector_item(option: "Pu238", desc: "Plutonium-238 (10kg)",     selected: false),
  ncmselector_item(option: "Pu239", desc: "Plutonium-239 (10kg)",     selected: false),
  ncmselector_item(option: "Pu240", desc: "Plutonium-240 (40kg)",     selected: false),
  ncmselector_item(option: "Pu241", desc: "Plutonium-241 (13kg)",     selected: false),
  ncmselector_item(option: "Am241", desc: "Americium-241 (100kg)",    selected: false),
  ncmselector_item(option: "Pu242", desc: "Plutonium-242 (100kg)",    selected: false),
  ncmselector_item(option: "Am242", desc: "Americium-242 (18kg)",     selected: false),
  ncmselector_item(option: "Am243", desc: "Americium-243 (155kg)",    selected: false),
  ncmselector_item(option: "Cm243", desc: "Curium-243 (10kg)",        selected: false),
  ncmselector_item(option: "Cm244", desc: "Curium-244 (30kg)",        selected: false),
  ncmselector_item(option: "Cm245", desc: "Curium-245 (13kg)",        selected: false),
  ncmselector_item(option: "Cm246", desc: "Curium-246 (84kg)",        selected: false),
  ncmselector_item(option: "Cm247", desc: "Curium-247 (7kg)",         selected: false),
  ncmselector_item(option: "Bk247", desc: "Berkelium-247 (10kg)",     selected: false),
  ncmselector_item(option: "Cf249", desc: "Californium-249 (6kg)",    selected: false),
  ncmselector_item(option: "Cf251", desc: "Californium-251 (9kg)",    selected: false),
  ncmselector_item(option: nil,     desc: nil,                        selected: false)
]

var sopts = ncmultiselector_options(
  title        : "this is truly an awfully long example of a MULTISELECTOR title",
  secondary    : "pick one (you will die regardless)",
  footer       : "press q to exit (there is sartrev(\"no exit\"))",
  items        : cast[ptr UncheckedArray[ncmselector_item]](addr items),
  maxdisplay   : 10.cuint,
  opchannels   : NCCHANNELS_INITIALIZER(0xe0, 0x80, 0x40, 0x00, 0x00, 0x00),
  descchannels : NCCHANNELS_INITIALIZER(0x80, 0xe0, 0x40, 0x00, 0x00, 0x00),
  titlechannels: NCCHANNELS_INITIALIZER(0x20, 0xff, 0xff, 0x00, 0x00, 0x20),
  footchannels : NCCHANNELS_INITIALIZER(0xe0, 0x00, 0x40, 0x20, 0x20, 0x00),
  boxchannels  : NCCHANNELS_INITIALIZER(0x20, 0xe0, 0xe0, 0x20, 0x00, 0x00)
)

var bgchannels = NCCHANNELS_INITIALIZER(0x00, 0x20, 0x00, 0x00, 0x20, 0x00)
discard ncchannels_set_fg_alpha(addr bgchannels, NCALPHA_BLEND.cuint)
discard ncchannels_set_bg_alpha(addr bgchannels, NCALPHA_BLEND.cuint)

proc stopAndCrash(msg: string) =
  if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "Notcurses failed to stop")
  raise (ref Defect)(msg: msg)

let stdn = notcurses_stdplane nc

if notcurses_canopen_images nc:
  let ncv = ncvisual_from_file(joinPath(currentSourcePath.parentDir, "data/covid19.jpg").cstring)
  if isNil ncv: stopAndCrash "ncvisual_from_file failed"
  var vopts = ncvisual_options(n: stdn, scaling: NCSCALE_STRETCH)
  if isNil ncvisual_blit(nc, ncv, addr vopts): stopAndCrash "ncvisual_blit failed"

discard ncplane_set_fg_rgb(stdn, 0x40f040)
discard ncplane_putstr_aligned(stdn, 0, NCALIGN_RIGHT, "multiselect widget demo")

var
  nopts = ncplane_options(y: 3, x: 0, rows: 1, cols: 1)
  mseln = ncplane_create(stdn, addr nopts)

if isNil mseln: stopAndCrash "ncplane_create failed"
discard ncplane_set_base(mseln, "", 0, bgchannels)

var
  item = 0
  ns = ncmultiselector_create(mseln, addr sopts)

func toBytes(buf: array[5, cchar]): seq[byte] =
  const nullC = '\x00'.cchar
  var bytes: seq[byte]
  bytes.add buf[0].byte
  for c in buf[1..3]:
    if c != nullC: bytes.add c.byte
    else: break
  bytes

proc run_mselect() =
  const HIGH_UCS32 = 0x0010ffff'u32
  inc item
  if isNil ns:
    stopAndCrash "ncmultiselector_create failed to create selector " & $item
  discard notcurses_render(nc)
  var
    codepoint: uint32
    ni = ncinput()
  while (codepoint = notcurses_get_blocking(nc, addr ni);
         codepoint != high(uint32)):
    if ni.evtype == NCTYPE_RELEASE: continue
    if not ncmultiselector_offer_input(ns, addr ni):
      if codepoint == NCKEY_ENTER: break
      if codepoint <= HIGH_UCS32:
        let utf8 = string.fromBytes(toBytes(ni.utf8))
        case utf8:
          of "M", "J":
            if ncinput_ctrl_p(addr ni): break
          of "q": break
          else: discard
    discard notcurses_render(nc)
  ncmultiselector_destroy(ns)

run_mselect()

sopts.title = "short round title"
mseln = ncplane_create(stdn, addr nopts)
discard ncplane_set_base(mseln, "", 0, bgchannels)
ns = ncmultiselector_create(mseln, addr sopts)
run_mselect()

sopts.title = "short round title"
sopts.secondary = "now this secondary is also very, very, very outlandishly long, you see"
mseln = ncplane_create(stdn, addr nopts)
discard ncplane_set_base(mseln, "", 0, bgchannels)
ns = ncmultiselector_create(mseln, addr sopts)
run_mselect()

sopts.title = "the whole world is watching"
sopts.secondary = nil
sopts.footer = "now this FOOTERFOOTER is also very, very, very outlandishly long, you see"
mseln = ncplane_create(stdn, addr nopts)
discard ncplane_set_base(mseln, "", 0, bgchannels)
ns = ncmultiselector_create(mseln, addr sopts)
run_mselect()

sopts.title = "chomps"
sopts.secondary = nil
sopts.footer = nil
mseln = ncplane_create(stdn, addr nopts)
discard ncplane_set_base(mseln, "", 0, bgchannels)
ns = ncmultiselector_create(mseln, addr sopts)
run_mselect()

if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "Notcurses failed to stop")
