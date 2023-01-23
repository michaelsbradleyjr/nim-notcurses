import std/os
import notcurses
# this example uses Notcurses' multimedia stack so can't do `import notcurses/core`

# delete me
import notcurses/abi

# selection with mouse in `multiselect` PoC is not working
# https://github.com/dankamongmen/notcurses/issues/2699

let
  nc = Nc.init
  stdn = nc.stdPlane

proc nop() {.noconv.} = discard
setControlCHook(nop)

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

discard notcurses_mice_enable(nc.abiPtr, NCMICE_BUTTON_EVENT)

var sopts = ncmultiselector_options(
  title        : "this is truly an awfully long example of a MULTISELECTOR title",
  secondary    : "pick one (you will die regardless)",
  footer       : "press q to exit (there is sartrev(\"no exit\"))",
  items        : cast[ptr UncheckedArray[ncmselector_item]](addr items),
  maxdisplay   : 10.cuint,
  opchannels   : NcChannel.init(0xe0, 0x80, 0x40, 0x00, 0x00, 0x00).uint64,
  descchannels : NcChannel.init(0x80, 0xe0, 0x40, 0x00, 0x00, 0x00).uint64,
  titlechannels: NcChannel.init(0x20, 0xff, 0xff, 0x00, 0x00, 0x20).uint64,
  footchannels : NcChannel.init(0xe0, 0x00, 0x40, 0x20, 0x20, 0x00).uint64,
  boxchannels  : NcChannel.init(0x20, 0xe0, 0xe0, 0x20, 0x00, 0x00).uint64
)

var bgchannels = NcChannel.init(0x00, 0x20, 0x00, 0x00, 0x20, 0x00).uint64

discard ncchannels_set_fg_alpha(addr bgchannels, NCALPHA_BLEND.cuint)
discard ncchannels_set_bg_alpha(addr bgchannels, NCALPHA_BLEND.cuint)

if notcurses_canopen_images(nc.abiPtr):
  let ncv = ncvisual_from_file(joinPath(currentSourcePath.parentDir.parentDir,
    "data/covid19.jpg").cstring)
  var vopts = ncvisual_options(n: stdn.abiPtr, scaling: NCSCALE_STRETCH)
  discard ncvisual_blit(nc.abiPtr, ncv, addr vopts)

discard ncplane_set_fg_rgb(stdn.abiPtr, 0x40f040)

discard ncplane_putstr_aligned(stdn.abiPtr, 0, NCALIGN_RIGHT, "multiselect widget demo".cstring)

var nopts = ncplane_options(y: 3.cint, x: 0.cint, rows: 1.cuint, cols: 1.cuint)

var mseln = ncplane_create(stdn.abiPtr, addr nopts)

discard ncplane_set_base(mseln, "".cstring, 0, bgchannels)

var ns = ncmultiselector_create(mseln, addr sopts)

proc run_mselect() =
  nc.render.expect
  while true:
    var ni = nc.getBlocking
    if ni.event == Release: continue
    if not ncmultiselector_offer_input(ns, addr ni.abiObj):
      let key = ni.toKey
      if key.isSome and key.get == Enter:
        ncmultiselector_destroy(ns)
        return
      let utf8 = ni.toUTF8
      if utf8.isSome:
        case utf8.get:
          of "M", "J":
            if ncinput_ctrl_p(addr ni.abiObj):
              ncmultiselector_destroy(ns)
              return
        if utf8.get == "q": break
    nc.render.expect
  ncmultiselector_destroy(ns)

run_mselect()

sopts.title = "short round title".cstring
mseln = ncplane_create(stdn.abiPtr, addr nopts)
discard ncplane_set_base(mseln, "".cstring, 0, bgchannels)
ns = ncmultiselector_create(mseln, addr sopts)
run_mselect()

sopts.title = "short round title".cstring
sopts.secondary = "now this secondary is also very, very, very outlandishly long, you see"
mseln = ncplane_create(stdn.abiPtr, addr nopts)
discard ncplane_set_base(mseln, "".cstring, 0, bgchannels)
ns = ncmultiselector_create(mseln, addr sopts)
run_mselect()

sopts.title = "the whole world is watching".cstring
sopts.secondary = nil
sopts.footer = "now this FOOTERFOOTER is also very, very, very outlandishly long, you see"
mseln = ncplane_create(stdn.abiPtr, addr nopts)
discard ncplane_set_base(mseln, "".cstring, 0, bgchannels)
ns = ncmultiselector_create(mseln, addr sopts)
run_mselect()

sopts.title = "chomps".cstring
sopts.secondary = nil
sopts.footer = nil
mseln = ncplane_create(stdn.abiPtr, addr nopts)
discard ncplane_set_base(mseln, "".cstring, 0, bgchannels)
ns = ncmultiselector_create(mseln, addr sopts)
run_mselect()
