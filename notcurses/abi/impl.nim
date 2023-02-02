# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include/notcurses

import std/[macros, strutils, terminal]

type
  AbiDefect = object of Defect
  wchar_t* {.header: "<wchar.h>", importc.} = object

const nc_header = "notcurses/notcurses.h"

when ncStatic:
  {.pragma: nc, cdecl, header: nc_header, importc.}
  {.pragma: nc_init, cdecl, header: nc_header, importc.}
else:
  {.pragma: nc, cdecl, dynlib: nc_lib, importc.}
  {.pragma: nc_init, cdecl, dynlib: nc_init_lib, importc.}

{.pragma: nc_bycopy, bycopy, header: nc_header.}
{.pragma: nc_incomplete, header: nc_header, incompleteStruct.}

# L187 notcurses/nckeys.h
func nckey_synthesized_p*(w: uint32): bool =
  w >= PRETERUNICODEBASE and w <= NCKEY_EOF

# L201 notcurses/nckeys.h
func nckey_pua_p*     (w: uint32): bool = w >= 0x0000e000 and w <= 0x0000f8ff

# L207 notcurses/nckeys.h
func nckey_supppuaa_p*(w: uint32): bool = w >= 0x000f0000 and w <= 0x000ffffd

# L213 notcurses/nckeys.h
func nckey_supppuab_p*(w: uint32): bool = w >= 0x00100000 and w <= 0x0010fffd

# L39 - notcurses/notcurses.h
proc notcurses_version*(): cstring {.nc.}

# L42 - notcurses/notcurses.h
proc notcurses_version_components*(major, minor, patch, tweak: ptr cint) {.nc.}

type
  # L44 - notcurses/notcurses.h
  notcurses*       {.nc_incomplete, importc: "struct notcurses"      .} = object
  ncplane*         {.nc_incomplete, importc: "struct ncplane"        .} = object
  ncvisual*        {.nc_incomplete, importc: "struct ncvisual"       .} = object
  ncuplot*         {.nc_incomplete, importc: "struct ncuplot"        .} = object
  ncdplot*         {.nc_incomplete, importc: "struct ncdplot"        .} = object
  ncprogbar*       {.nc_incomplete, importc: "struct ncprogbar"      .} = object
  ncfdplane*       {.nc_incomplete, importc: "struct ncfdplane"      .} = object
  ncsubproc*       {.nc_incomplete, importc: "struct ncsubproc"      .} = object
  ncselector*      {.nc_incomplete, importc: "struct ncselector"     .} = object
  ncmultiselector* {.nc_incomplete, importc: "struct ncmultiselector".} = object
  ncreader*        {.nc_incomplete, importc: "struct ncreader"       .} = object
  ncfadectx*       {.nc_incomplete, importc: "struct ncfadectx"      .} = object
  nctablet*        {.nc_incomplete, importc: "struct nctablet"       .} = object
  ncreel*          {.nc_incomplete, importc: "struct ncreel"         .} = object
  nctab*           {.nc_incomplete, importc: "struct nctab"          .} = object
  nctabbed*        {.nc_incomplete, importc: "struct nctabbed"       .} = object
  ncdirect*        {.nc_incomplete, importc: "struct ncdirect"       .} = object

# L127 - notcurses/notcurses.h
macro NCCHANNEL_INITIALIZER*(r, g, b: cuint): uint32 =
  quote do:
    (`r` shl 16) + (`g` shl 8) + `b` + NC_BGDEFAULT_MASK.uint32

# L131 - notcurses/notcurses.h
macro NCCHANNELS_INITIALIZER*(fr, fg, fb, br, bg, bb: cuint): uint64 =
  quote do:
    let
      chan1 = NCCHANNEL_INITIALIZER(`fr`, `fg`, `fb`).uint64
      chan2 = NCCHANNEL_INITIALIZER(`br`, `bg`, `bb`).uint64
    (chan1 shl 32) + chan2

# L367 - notcurses/notcurses.h
proc ncchannels_set_bg_alpha*(channels: ptr uint64, alpha: cuint): cint {.nc.}

# L387 - notcurses/notcurses.h
proc ncchannels_set_fg_alpha*(channels: ptr uint64, alpha: cuint): cint {.nc.}

# L609 - notcurses/notcurses.h
proc notcurses_ucs32_to_utf8*(ucs32: ptr uint32, ucs32count: cuint, resultbuf: ptr UncheckedArray[cchar], buflen: csize_t): cint {.nc.}

type
  # L1060 - notcurses/notcurses.h
  notcurses_options* {.nc_bycopy, importc: "struct notcurses_options".} = object
    termtype*: cstring
    loglevel*: ncloglevel_e
    margin_t*: cuint
    margin_r*: cuint
    margin_b*: cuint
    margin_l*: cuint
    flags*   : uint64

when not ncCore:
  # L1087 - notcurses/notcurses.h
  proc notcurses_init*(opts: ptr notcurses_options, fp: File): ptr notcurses {.nc_init.}
else:
  # L1091 - notcurses/notcurses.h
  proc notcurses_core_init*(opts: ptr notcurses_options, fp: File): ptr notcurses {.nc_init.}

# L1094 - notcurses/notcurses.h
proc notcurses_stop*(nc: ptr notcurses): cint {.nc.}

# L1111 - notcurses/notcurses.h
proc notcurses_stdplane*(nc: ptr notcurses): ptr ncplane {.nc.}

# L1138 - notcurses/notcurses.h
proc ncpile_render*(n: ptr ncplane): cint {.nc.}

# L1144 - notcurses/notcurses.h
proc ncpile_rasterize*(n: ptr ncplane): cint {.nc.}

# L1149 - notcurses/notcurses.h
proc notcurses_render*(nc: ptr notcurses): cint {.nc.}

type
  # L1217 - notcurses/notcurses.h
  ncinput* {.nc_bycopy, importc: "struct ncinput".} = object
    id*       : uint32
    y*        : cint
    x*        : cint
    utf8*     : array[5, cchar]
    alt*      : bool
    shift*    : bool
    ctrl*     : bool
    evtype*   : ncintype_e
    modifiers*: cuint
    ypx*      : cint
    xpx*      : cint

# L1225 - notcurses/notcurses.h
proc ncinput_ctrl_p*(ni: ptr ncinput): bool {.nc.}

# L1322 - notcurses/notcurses.h
proc notcurses_get_blocking*(n: ptr notcurses, ni: ptr ncinput): uint32 {.nc.}

# L1341 - notcurses/notcurses.h
proc notcurses_mice_enable*(n: ptr notcurses, eventmask: cuint): cint {.nc.}

# L1346 - notcurses/notcurses.h
proc notcurses_mice_disable*(n: ptr notcurses): cint {.nc.}

# L1376 - notcurses/notcurses.h
proc ncplane_dim_yx*(n: ptr ncplane, y, x: ptr cuint) {.nc.}

# L1387 - notcurses/notcurses.h
proc notcurses_stddim_yx*(nc: ptr notcurses, y, x: ptr cuint): ptr ncplane {.nc.}

type
  # L1472 -  notcurses/notcurses.h
  ncplane_options* {.nc_bycopy, importc: "struct ncplane_options".} = object
    y*       : cint
    x*       : cint
    rows*    : cuint
    cols*    : cuint
    userptr* : pointer
    name*    : cstring
    resizecb*: proc (n: ptr ncplane): cint {.noconv.}
    flags*   : uint64
    margin_b*: cuint
    margin_r*: cuint

# L1479 - notcurses/notcurses.h
proc ncplane_create*(n: ptr ncplane, nopts: ptr ncplane_options): ptr ncplane {.nc.}

# L1562 - notcurses/notcurses.h
proc ncplane_set_scrolling*(n: ptr ncplane, scrollp: cuint): bool {.nc.}

# L1565 - notcurses/notcurses.h
proc ncplane_scrolling_p*(n: ptr ncplane): bool {.nc.}

# L1727 - notcurses/notcurses.h
proc notcurses_canopen_images*(nc: ptr notcurses): bool {.nc.}

# L1874 - notcurses/notcurses.h
proc ncplane_set_base*(n: ptr ncplane, egc: cstring, stylemask: uint16, channels: uint64): cint {.nc.}

# L2264 - notcurses/notcurses.h
proc ncplane_putstr_yx*(n: ptr ncplane, y, x: cint, gclusters: cstring): cint {.nc.}

# L2287 - notcurses/notcurses.h
proc ncplane_putstr*(n: ptr ncplane, gclustarr: cstring): cint {.nc.}

# L2292 - notcurses/notcurses.h
proc ncplane_putstr_aligned*(n: ptr ncplane, y: cint, align: ncalign_e, s: cstring): cint {.nc.}

# L2433 - notcurses/notcurses.h
proc ncplane_putwc*(n: ptr ncplane, w: wchar_t): cint {.nc.}

# L2680 - notcurses/notcurses.h
proc ncplane_gradient*(n: ptr ncplane, y, x: cint, ylen, xlen: cuint, egc: cstring, styles: uint16, ul, ur, ll, lr: uint64): cint {.nc.}

# L2689 - notcurses/notcurses.h
proc ncplane_gradient2x1*(n: ptr ncplane, y, x: cint, ylen, xlen: cuint, ul, ur, ll, lr: uint32): cint {.nc.}

# L2927 - notcurses/notcurses.h
proc ncplane_set_styles*(n: ptr ncplane, stylebits: cuint) {.nc.}

# L3000 - notcurses/notcurses.h
proc ncplane_set_fg_rgb*(n: ptr ncplane, channel: uint32): cint {.nc.}

# L3001 - notcurses/notcurses.h
proc ncplane_set_bg_rgb*(n: ptr ncplane, channel: uint32): cint {.nc.}

# L3257 - notcurses/notcurses.h
proc ncvisual_from_file*(file: cstring): ptr ncvisual {.nc.}

type
  # L3324 - notcurses/notcurses.h
  ncvisual_options* {.nc_bycopy, importc: "struct ncvisual_options".} = object
    n*         : ptr ncplane
    scaling*   : ncscale_e
    y*         : cint
    x*         : cint
    begy*      : cuint
    begx*      : cuint
    leny*      : cuint
    lenx*      : cuint
    blitter*   : ncblitter_e
    flags*     : uint64
    transcolor*: uint32
    pxoffy*    : cuint
    pxoffx*    : cuint

# L3453 - notcurses/notcurses.h
proc ncvisual_blit*(nc: ptr notcurses, ncv: ptr ncvisual, vopts: ptr ncvisual_options): ptr ncplane {.nc.}

type
  # L3946 - notcurses/notcurses.h
  ncmselector_item* {.nc_bycopy, importc: "struct ncmselector_item".} = object
    option*  : cstring
    desc*    : cstring
    selected*: bool

  # L3987 - notcurses/notcurses.h
  ncmultiselector_options* {.nc_bycopy, importc: "struct ncmultiselector_options".} = object
    title*        : cstring
    secondary*    : cstring
    footer*       : cstring
    items*        : ptr UncheckedArray[ncmselector_item]
    maxdisplay*   : cuint
    opchannels*   : uint64
    descchannels* : uint64
    titlechannels*: uint64
    footchannels* : uint64
    boxchannels*  : uint64
    flags*        : uint64

# L3989 - notcurses/notcurses.h
proc ncmultiselector_create*(n: ptr ncplane, opts: ptr ncmultiselector_options): ptr ncmultiselector {.nc.}

# L4006 - notcurses/notcurses.h
proc ncmultiselector_offer_input*(n: ptr ncmultiselector, ni: ptr ncinput): bool {.nc.}

# L4010 - notcurses/notcurses.h
proc ncmultiselector_destroy*(n: ptr ncmultiselector) {.nc.}

when ncStatic:
  const ncd_header = "notcurses/direct.h"
  {.pragma: ncd, cdecl, header: ncd_header, importc.}
  {.pragma: ncd_init, cdecl, header: ncd_header, importc.}
else:
  {.pragma: ncd, cdecl, dynlib: nc_lib, importc.}
  {.pragma: ncd_init, cdecl, dynlib: nc_init_lib, importc.}

when not ncCore:
  # L59 - notcurses/direct.h
  proc ncdirect_init*(termtype: cstring, fp: File, flags: uint64): ptr ncdirect {.ncd_init.}
else:
  # L63 - notcurses/direct.h
  proc ncdirect_core_init*(termtype: cstring, fp: File, flags: uint64): ptr ncdirect {.ncd_init.}

# L92 - notcurses/direct.h
proc ncdirect_putstr*(nc: ptr ncdirect, channels: uint64, utf8: cstring): cint {.ncd.}

# L279 - notcurses/direct.h
proc ncdirect_stop*(nc: ptr ncdirect): cint {.ncd.}

var
  lib_notcurses_major: cint
  lib_notcurses_minor: cint
  lib_notcurses_patch: cint
  lib_notcurses_tweak: cint

notcurses_version_components(addr lib_notcurses_major, addr lib_notcurses_minor, addr lib_notcurses_patch, addr lib_notcurses_tweak)

if nim_notcurses_version.major != lib_notcurses_major:
  let majorMismatchMsg = ("""
nim-notcurses major version $1 is not compatible with Notcurses library major
version $4 (nim-notcurses: $1.$2.$3, libnotcurses: $5)
  """ % [
    $nim_notcurses_version.major,
    $nim_notcurses_version.minor,
    $nim_notcurses_version.patch,
    $lib_notcurses_major,
    $notcurses_version()
  ]).strip.replace("\n", " ")
  styledWriteLine(stderr, fgRed, "Error: ", resetStyle, majorMismatchMsg)
  raise (ref AbiDefect)(msg: "libnotcurses major version mismatch")

const ncWarnMinor {.booldefine.}: bool = true

when ncWarnMinor:
  if (nim_notcurses_version.major, nim_notcurses_version.minor) >
      (lib_notcurses_major, lib_notcurses_minor):
    let minorMismatchMsg = ("""
nim-notcurses minor version $1.$2 is newer than Notcurses library minor
version $4.$5 (nim-notcurses: $1.$2.$3, libnotcurses: $6)
    """ % [
      $nim_notcurses_version.major,
      $nim_notcurses_version.minor,
      $nim_notcurses_version.patch,
      $lib_notcurses_major,
      $lib_notcurses_minor,
      $notcurses_version()
    ]).strip.replace("\n", " ")
    styledWriteLine(stderr, fgYellow, "Warning: ", resetStyle, minorMismatchMsg)
