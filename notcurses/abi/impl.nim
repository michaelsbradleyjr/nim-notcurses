import std/macros

import ./constants
export constants

type
  AbiDefect = object of Defect
  wchar_t* {.importc.} = object

const
  nc_header = "notcurses/notcurses.h"
  nc_init_name = nc_init_prefix & "init"

when NcStatic:
  {.pragma: nc, cdecl, header: nc_header, importc.}
  {.pragma: nc_bycopy, bycopy, header: nc_header.}
  {.pragma: nc_incomplete, header: nc_header, incompleteStruct.}
  {.pragma: nc_init, cdecl, header: nc_header, importc: nc_init_name.}
else:
  {.pragma: nc, cdecl, dynlib: nc_lib, importc.}
  {.pragma: nc_bycopy, bycopy, header: nc_header.}
  {.pragma: nc_incomplete, header: nc_header, incompleteStruct.}
  {.pragma: nc_init, cdecl, dynlib: nc_init_lib, importc: nc_init_name.}

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
  # ncdirect*      {.nc_incomplete, importc: "struct ncdirect"       .} = object
  # nim-notcurses does not support Direct mode, it's recommended to use CLI mode instead
  # For more context see https://github.com/dankamongmen/notcurses/issues/1834

# L127 - notcurses/notcurses.h
macro NCCHANNEL_INITIALIZER*(r, g, b: cint): culonglong =
  quote do:
    let
      rr  = `r`.culonglong
      gg  = `g`.culonglong
      bb  = `b`.culonglong
    (rr shl 16) + (gg shl 8) + bb + NC_BGDEFAULT_MASK

# L131 - notcurses/notcurses.h
macro NCCHANNELS_INITIALIZER*(fr, fg, fb, br, bg, bb: cint): culonglong =
  quote do:
    let
      chan1 = NCCHANNEL_INITIALIZER(`fr`, `fg`, `fb`)
      chan2 = NCCHANNEL_INITIALIZER(`br`, `bg`, `bb`)
    (chan1 shl 32) + chan2

# L367 - notcurses/notcurses.h
proc ncchannels_set_bg_alpha*(channels: ptr uint64, alpha: cuint): cint {.nc.}

# L387 - notcurses/notcurses.h
proc ncchannels_set_fg_alpha*(channels: ptr uint64, alpha: cuint): cint {.nc.}

type
  # L982 - notcurses/notcurses.h
  notcurses_options* {.nc_bycopy, importc: "struct notcurses_options".} = object
    termtype*: cstring
    loglevel*: ncloglevel_e
    margin_t*: cuint
    margin_r*: cuint
    margin_b*: cuint
    margin_l*: cuint
    flags*   : culonglong

# L1026, L1030 - notcurses/notcurses.h
proc notcurses_init*(opts: ptr notcurses_options, fp: File): ptr notcurses {.nc_init.}

# L1033 - notcurses/notcurses.h
proc notcurses_stop*(nc: ptr notcurses): cint {.nc.}

# L1050 - notcurses/notcurses.h
proc notcurses_stdplane*(nc: ptr notcurses): ptr ncplane {.nc.}

# L1077 - notcurses/notcurses.h
proc ncpile_render*(n: ptr ncplane): cint {.nc.}

# L1083 - notcurses/notcurses.h
proc ncpile_rasterize*(n: ptr ncplane): cint {.nc.}

# L1088 - notcurses/notcurses.h
proc notcurses_render*(nc: ptr notcurses): cint {.nc.}

type
  # L1144 - notcurses/notcurses.h
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

# L1261 - notcurses/notcurses.h
proc notcurses_get_blocking*(n: ptr notcurses, ni: ptr ncinput): uint32 {.nc.}

# L1315 - notcurses/notcurses.h
proc ncplane_dim_yx*(n: ptr ncplane, y, x: ptr cuint) {.nc.}

# L1326 - notcurses/notcurses.h
proc notcurses_stddim_yx*(nc: ptr notcurses, y, x: ptr cuint): ptr ncplane {.nc.}

# L1340 - notcurses/notcurses.h
proc notcurses_mice_enable*(n: ptr notcurses, eventmask: cuint): cint {.nc.}

# L1345 - notcurses/notcurses.h
proc notcurses_mice_disable*(n: ptr notcurses): cint {.nc.}

type
  # L1462 -  notcurses/notcurses.h
  ncplane_options* {.nc_bycopy, importc: "struct ncplane_options".} = object
    y*:        cint
    x*:        cint
    rows*:     cuint
    cols*:     cuint
    userptr*:  pointer
    name*:     cstring
    resizecb*: proc (n: ptr ncplane): cint {.noconv.}
    flags*:    uint64
    margin_b*: cuint
    margin_r*: cuint

# L1479 - notcurses/notcurses.h
proc ncplane_create*(n: ptr ncplane, nopts: ptr ncplane_options): ptr ncplane {.nc.}

# L1501 - notcurses/notcurses.h
proc ncplane_set_scrolling*(n: ptr ncplane, scrollp: cuint): bool {.nc.}

# L1504 - notcurses/notcurses.h
proc ncplane_scrolling_p*(n: ptr ncplane): bool {.nc.}

# L1726 - notcurses/notcurses.h
proc notcurses_canopen_images*(nc: ptr notcurses): bool {.nc.}

# L1874 - notcurses/notcurses.h
proc ncplane_set_base*(n: ptr ncplane, egc: cstring, stylemask: uint16, channels: uint64): cint {.nc.}

# L2225 - notcurses/notcurses.h
proc ncplane_putstr*(n: ptr ncplane, gclustarr: cstring): cint {.nc.}

# L2265 - notcurses/notcurses.h
proc ncplane_putstr_yx*(n: ptr ncplane, y, x: cint, gclustarr: cstring): cint {.nc.}

# L2292 - notcurses/notcurses.h
proc ncplane_putstr_aligned*(n: ptr ncplane, y: cint, align: ncalign_e, s: cstring): cint {.nc.}

# L2371 - notcurses/notcurses.h
proc ncplane_putwc*(n: ptr ncplane, w: wchar_t): cint {.nc.}

# L2618 - notcurses/notcurses.h
proc ncplane_gradient*(n: ptr ncplane, y, x: cint, ylen, xlen: cuint, egc: cstring, styles: uint16, ul, ur, ll, lr: uint64): cint {.nc.}

# L2627 - notcurses/notcurses.h
proc ncplane_gradient2x1*(n: ptr ncplane, y, x: cint, ylen, xlen: cuint, ul, ur, ll, lr: uint32): cint {.nc.}

# L2850 - notcurses/notcurses.h
proc ncplane_set_styles*(n: ptr ncplane, stylebits: cuint) {.nc.}

# L3000 - notcurses/notcurses.h
proc ncplane_set_fg_rgb*(n: ptr ncplane, channel: uint32): cint {.nc.}

# L3001 - notcurses/notcurses.h
proc ncplane_set_bg_rgb*(n: ptr ncplane, channel: uint32): cint {.nc.}

# L3255 - notcurses/notcurses.h
proc ncvisual_from_file*(file: cstring): ptr ncvisual {.nc.}

type
  # L3322 - notcurses/notcurses.h
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
  # L3870 - notcurses/notcurses.h
  ncmselector_item* {.nc_bycopy, importc: "struct ncmselector_item".} = object
    option*  : cstring
    desc*    : cstring
    selected*: bool

  # L3911 - notcurses/notcurses.h
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
proc ncmultiselector_create*(n: ptr ncplane, opts: ptr ncmultiselector_options): ptr ncmultiselector {.nc}

# L4006 - notcurses/notcurses.h
proc ncmultiselector_offer_input*(n: ptr ncmultiselector, ni: ptr ncinput): bool {.nc.}

# L4010 - notcurses/notcurses.h
proc ncmultiselector_destroy*(n: ptr ncmultiselector) {.nc.}

var
  lib_notcurses_major*: cint
  lib_notcurses_minor*: cint
  lib_notcurses_patch*: cint
  lib_notcurses_tweak*: cint

notcurses_version_components(addr lib_notcurses_major, addr lib_notcurses_minor, addr lib_notcurses_patch, addr lib_notcurses_tweak)

if nim_notcurses_version.major != lib_notcurses_major:
  raise (ref AbiDefect)(msg:
    "nim-notcurses major version " &
    $nim_notcurses_version.major &
    " is not compatible with Notcurses library major version " &
    $lib_notcurses_major & " (nim-notcurses: " & $nim_notcurses_version.major &
    "." & $nim_notcurses_version.minor & "." & $nim_notcurses_version.patch &
    ", libnotcurses: " & $notcurses_version() & ")")
