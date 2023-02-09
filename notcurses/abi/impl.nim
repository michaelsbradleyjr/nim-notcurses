# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include/notcurses

import std/[macros, strutils, terminal]

# L187 notcurses/nckeys.h
proc nckey_synthesized_p*(w: uint32): bool {.nc_keys.}

# L201 notcurses/nckeys.h
proc nckey_pua_p*(w: uint32): bool {.nc_keys.}

# L207 notcurses/nckeys.h
proc nckey_supppuaa_p*(w: uint32): bool {.nc_keys.}

# L213 notcurses/nckeys.h
proc nckey_supppuab_p*(w: uint32): bool {.nc_keys.}

# L39 - notcurses/notcurses.h
proc notcurses_version*(): cstring {.nc.}

# L42 - notcurses/notcurses.h
proc notcurses_version_components*(major, minor, patch, tweak: ptr cint) {.nc.}

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

# L142 - notcurses/notcurses.h
proc ncchannel_alpha*(channel: uint32): cuint {.nc.}

# L150 - notcurses/notcurses.h
proc ncchannel_set_alpha*(channel: uint32, alpha: cuint): cint {.nc.}

# L163 - notcurses/notcurses.h
proc ncchannel_default_p*(channel: uint32): bool {.nc.}

# L169 - notcurses/notcurses.h
proc ncchannel_set_default*(channel: uint32): uint32 {.nc.}

# L177 - notcurses/notcurses.h
proc ncchannel_palindex_p*(channel: uint32): bool {.nc.}

# L184 - notcurses/notcurses.h
proc ncchannel_palindex*(channel: uint32): cuint {.nc.}

# L191 - notcurses/notcurses.h
proc ncchannel_set_palindex*(channel: ptr uint32, idx: cuint): cint {.nc.}

# L203 - notcurses/notcurses.h
proc ncchannel_rgb_p*(channel: uint32): bool {.nc.}

# L211 - notcurses/notcurses.h
proc ncchannel_r*(channel: uint32): cuint {.nc.}

# L218 - notcurses/notcurses.h
proc ncchannel_g*(channel: uint32): cuint {.nc.}

# L225 - notcurses/notcurses.h
proc ncchannel_b*(channel: uint32): cuint {.nc.}

# L232 - notcurses/notcurses.h
proc ncchannel_rgb*(channel: uint32): uint32 {.nc.}

# L239 - notcurses/notcurses.h
proc ncchannel_rgb8*(channel: uint32, r, g, b: ptr cuint): uint32 {.nc.}

# L251 - notcurses/notcurses.h
proc ncchannel_set_rgb8*(channel: ptr uint32, r, g, b: cuint): cint {.nc.}

# L264 - notcurses/notcurses.h
proc ncchannel_set*(channel: ptr uint32, rgb: uint32): cint {.nc.}

# L276 - notcurses/notcurses.h
proc ncchannel_set_rgb8_clipped(channel: ptr uint32, r, g, b: cint) {.nc.}

# L302 - notcurses/notcurses.h
proc ncchannels_bchannel*(channels: uint64): uint32 {.nc.}

# L310 - notcurses/notcurses.h
proc ncchannels_fchannel*(channels: uint64): uint32 {.nc.}

# L316 - notcurses/notcurses.h
proc ncchannels_channels*(channels: uint64): uint64 {.nc.}

# L322 - notcurses/notcurses.h
proc ncchannels_bg_rgb_p*(channels: uint64): bool {.nc.}

# L327 - notcurses/notcurses.h
proc ncchannels_fg_rgb_p*(channels: uint64): bool {.nc.}

# L333 - notcurses/notcurses.h
proc ncchannels_bg_alpha*(channels: uint64): cuint {.nc.}

# L340 - notcurses/notcurses.h
proc ncchannels_set_bchannel*(channels: ptr uint64, channel: uint32): uint64 {.nc.}

# L350 - notcurses/notcurses.h
proc ncchannels_set_fchannel(channels: ptr uint64, channel: uint32): uint64 {.nc.}

# L359 - notcurses/notcurses.h
proc ncchannels_set_channels*(dst: ptr uint64, channels: uint64): uint64 {.nc.}

# L367 - notcurses/notcurses.h
proc ncchannels_set_bg_alpha*(channels: ptr uint64, alpha: cuint): cint {.nc.}

# L381 - notcurses/notcurses.h
proc ncchannels_fg_alpha*(channels: uint64): cuint {.nc.}

# L387 - notcurses/notcurses.h
proc ncchannels_set_fg_alpha*(channels: ptr uint64, alpha: cuint): cint {.nc.}

# L609 - notcurses/notcurses.h
proc notcurses_ucs32_to_utf8*(ucs32: ptr uint32, ucs32count: cuint, resultbuf: ptr UncheckedArray[cchar], buflen: csize_t): cint {.nc.}

# L1087 - notcurses/notcurses.h
proc notcurses_init*(opts: ptr notcurses_options, fp: File): ptr notcurses {.nc.}

# L1091 - notcurses/notcurses.h
proc notcurses_core_init*(opts: ptr notcurses_options, fp: File): ptr notcurses {.nc.}

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

# L2133 - notcurses/notcurses.h
proc ncplane_cursor_y*(n: ptr ncplane): cuint {.nc.}

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

# L3453 - notcurses/notcurses.h
proc ncvisual_blit*(nc: ptr notcurses, ncv: ptr ncvisual, vopts: ptr ncvisual_options): ptr ncplane {.nc.}

# L3989 - notcurses/notcurses.h
proc ncmultiselector_create*(n: ptr ncplane, opts: ptr ncmultiselector_options): ptr ncmultiselector {.nc.}

# L4006 - notcurses/notcurses.h
proc ncmultiselector_offer_input*(n: ptr ncmultiselector, ni: ptr ncinput): bool {.nc.}

# L4010 - notcurses/notcurses.h
proc ncmultiselector_destroy*(n: ptr ncmultiselector) {.nc.}

# L59 - notcurses/direct.h
proc ncdirect_init*(termtype: cstring, fp: File, flags: uint64): ptr ncdirect {.ncd.}

# L63 - notcurses/direct.h
proc ncdirect_core_init*(termtype: cstring, fp: File, flags: uint64): ptr ncdirect {.ncd.}

# L92 - notcurses/direct.h
proc ncdirect_putstr*(nc: ptr ncdirect, channels: uint64, utf8: cstring): cint {.ncd.}

# L142 - notcurses/direct.h
proc ncdirect_supported_styles*(nc: ptr ncdirect): uint16 {.ncd.}

# L146 - notcurses/direct.h
proc ncdirect_set_styles*(n: ptr ncdirect, stylebits: cuint): cint {.ncd.}

# L279 - notcurses/direct.h
proc ncdirect_stop*(nc: ptr ncdirect): cint {.ncd.}

var
  lib_notcurses_major: cint
  lib_notcurses_minor: cint
  lib_notcurses_patch: cint
  lib_notcurses_tweak: cint

notcurses_version_components(addr lib_notcurses_major, addr lib_notcurses_minor, addr lib_notcurses_patch, addr lib_notcurses_tweak)

type AbiDefect = object of Defect

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
