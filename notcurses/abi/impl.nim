# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include

import std/[macros, posix, strutils, terminal]
import pkg/stew/endians2

export Time, Timespec, toLE

# may need to revisit whether it's better to impl a (possibly more accurate)
# custom wrapper for timespec/time_t or use Timespec/Time from Nim's std/posix
# * https://nim-lang.org/docs/posix.html#Time
# * https://nim-lang.org/docs/posix.html#Timespec
# * https://en.cppreference.com/w/c/chrono/timespec

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
proc ncchannel_set_rgb8_clipped*(channel: ptr uint32, r, g, b: cint) {.nc.}

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
proc ncchannels_set_fchannel*(channels: ptr uint64, channel: uint32): uint64 {.nc.}

# L359 - notcurses/notcurses.h
proc ncchannels_set_channels*(dst: ptr uint64, channels: uint64): uint64 {.nc.}

# L367 - notcurses/notcurses.h
proc ncchannels_set_bg_alpha*(channels: ptr uint64, alpha: cuint): cint {.nc.}

# L381 - notcurses/notcurses.h
proc ncchannels_fg_alpha*(channels: uint64): cuint {.nc.}

# L387 - notcurses/notcurses.h
proc ncchannels_set_fg_alpha*(channels: ptr uint64, alpha: cuint): cint {.nc.}

# L401 - notcurses/notcurses.h
proc ncchannels_reverse*(channels: uint64): uint64 {.nc.}

# L424 - notcurses/notcurses.h
proc ncchannels_combine*(fchan: uint32, bchan: uint32): uint64 {.nc.}

# L432 - notcurses/notcurses.h
proc ncchannels_fg_palindex*(channels: uint64): cuint {.nc.}

# L437 - notcurses/notcurses.h
proc ncchannels_bg_palindex*(channels: uint64): cuint {.nc.}

# L443 - notcurses/notcurses.h
proc ncchannels_fg_rgb*(channels: uint64): uint32 {.nc.}

# L449 - notcurses/notcurses.h
proc ncchannels_bg_rgb*(channels: uint64): uint32 {.nc.}

# L455 - notcurses/notcurses.h
proc ncchannels_fg_rgb8*(channels: uint64, r, g, b: ptr cuint): uint32 {.nc.}

# L461 - notcurses/notcurses.h
proc ncchannels_bg_rgb8*(channels: uint64, r, g, b: ptr cuint): uint32 {.nc.}

# L468 - notcurses/notcurses.h
proc ncchannels_set_fg_rgb8*(channels: uint64, r, g, b: ptr cuint): cint {.nc.}

# L479 - notcurses/notcurses.h
proc ncchannels_set_fg_rgb8_clipped*(channels: ptr uint64, r, g, b: cint) {.nc.}

# L486 - notcurses/notcurses.h
proc ncchannels_set_fg_palindex*(channels: ptr uint64, idx: cuint): cint {.nc.}

# L497 - notcurses/notcurses.h
proc ncchannels_set_fg_rgb*(channels: ptr uint64, rgb: cuint): cint {.nc.}

# L509 - notcurses/notcurses.h
proc ncchannels_set_bg_rgb8*(channels: ptr uint64, r, g, b: cuint): cint {.nc.}

# L520 - notcurses/notcurses.h
proc ncchannels_set_bg_rgb8_clipped*(channels: ptr uint64, r, g, b: cint) {.nc.}

# L529 - notcurses/notcurses.h
proc ncchannels_set_bg_palindex*(channels: ptr uint64, idx: cuint): cint {.nc.}

# L540 - notcurses/notcurses.h
proc ncchannels_set_bg_rgb*(channels: ptr uint64, rgb: cuint): cint {.nc.}

# L551 - notcurses/notcurses.h
proc ncchannels_fg_default_p*(channels: uint64): bool {.nc.}

# L557 - notcurses/notcurses.h
proc ncchannels_fg_palindex_p*(channels: uint64): bool {.nc.}

# L565 - notcurses/notcurses.h
proc ncchannels_bg_default_p*(channels: uint64): bool {.nc.}

# L571 - notcurses/notcurses.h
proc ncchannels_bg_palindex_p*(channels: uint64): bool {.nc.}

# L577 - notcurses/notcurses.h
proc ncchannels_set_fg_default*(channels: ptr uint64): uint64 {.nc.}

# L586 - notcurses/notcurses.h
proc ncchannels_set_bg_default*(channels: ptr uint64): uint64 {.nc.}

# L601 - notcurses/notcurses.h
proc ncstrwidth*(egcs: cstring, validbytes, validwidth: ptr cint): cint {.nc.}

# L609 - notcurses/notcurses.h
proc notcurses_ucs32_to_utf8*(ucs32: ptr uint32, ucs32count: cuint, resultbuf: ptr UncheckedArray[cchar], buflen: csize_t): cint {.nc.}

# L731 - notcurses/notcurses.h
macro NCCELL_INITIALIZER*(c: uint32, s: uint16, chan: uint64): nccell =
  quote do:
    let
      gcluster = `c`.toLE
      wcw = `c`.wchar.wcwidth
      width = (if wcw <= 0: 1 else: wcw).uint8
    nccell(gcluster: gcluster, gcluster_backstop: 0, width: width, stylemask: `s`, channels: `chan`)

# L734 - notcurses/notcurses.h
macro NCCELL_CHAR_INITIALIZER*(c: cchar): nccell =
  quote do:
    let
      gcluster = `c`.uint32.toLE
      wcw = `c`.wchar.wcwidth
      width = (if wcw <= 0: 1 else: wcw).uint8
    nccell(gcluster: gcluster, gcluster_backstop: 0, width: width, stylemask: 0, channels: 0)

# L737 - notcurses/notcurses.h
template NCCELL_TRIVIAL_INITIALIZER*(): nccell =
  nccell(gcluster: 0, gcluster_backstop: 0, width: 1, stylemask: 0, channels: 0)

# L741 - notcurses/notcurses.h
proc nccell_init*(c: ptr nccell) {.nc.}

# L748 - notcurses/notcurses.h
proc nccell_load*(n: ptr ncplane, c: ptr nccell, gcluster: cstring): cint {.nc.}

# L752 - notcurses/notcursesh.
proc nccell_prime*(n: ptr ncplane, c: ptr nccell, gcluster: cstring, stylemask: uint16, channels: uint64): cint {.nc.}

# L762 - notcurses/notcurses.h
proc nccell_duplicate*(n: ptr ncplane, targ: ptr nccell, c: ptr nccell): cint {.nc.}

# L765 - notcurses/notcurses.h
proc nccell_release*(n: ptr ncplane, c: ptr nccell) {.nc.}

# L780 - notcurses/notcurses.h
proc nccell_set_styles*(c: ptr nccell, stylebits: cuint) {.nc.}

# L786 - notcurses/notcurses.h
proc nccell_styles*(c: ptr nccell): uint16 {.nc.}

# L793 - notcurses/notcurses.h
proc nccell_on_styles*(c: ptr nccell, stylebits: cuint) {.nc.}

# L799 - notcurses/notcurses.h
proc nccell_off_styles*(c: ptr nccell, stylebits: cuint) {.nc.}

# L805 - notcurses/notcurses.h
proc nccell_set_fg_default*(c: ptr nccell) {.nc.}

# L811 - notcurses/notcurses.h
proc nccell_set_bg_default*(c: ptr nccell) {.nc.}

# L816 - notcurses/notcurses.h
proc nccell_set_fg_alpha*(c: ptr nccell, alpha: cuint): cint {.nc.}

# L821 - notcurses/notcurses.h
proc nccell_set_bg_alpha*(c: ptr nccell, alpha: cuint): cint {.nc.}

# L826 - notcurses/notcurses.h
proc nccell_set_bchannel*(c: ptr nccell, channel: uint32): uint64 {.nc.}

# L831 - notcurses/notcurses.h
proc nccell_set_fchannel*(c: ptr nccell, channel: uint32): uint64 {.nc.}

# L836 - notcurses/notcurses.h
proc nccell_set_channels*(c: ptr nccell, channels: uint64): uint64 {.nc.}

# L842 - notcurses/notcurses.h
proc nccell_double_wide_p*(c: ptr nccell): bool {.nc.}

# L848 - notcurses/notcurses.h
proc nccell_wide_right_p*(c: ptr nccell): bool {.nc.}

# L854 - notcurses/notcurses.h
proc nccell_wide_left_p*(c: ptr nccell): bool {.nc.}

# L861 - notcurses/notcurses.h
proc nccell_extended_gcluster*(n: ptr ncplane, c: ptr nccell): cstring {.nc.}

# L864 - notcurses/notcurses.h
proc nccell_channels*(c: ptr nccell): uint64 {.nc.}

# L871 - notcurses/notcurses.h
proc nccell_bchannel*(cl: ptr nccell): uint32 {.nc.}

# L878 - notcurses/notcurses.h
proc nccell_fchannel*(cl: ptr nccell): uint32 {.nc.}

# L885 - notcurses/notcurses.h
proc nccell_cols*(c: ptr nccell): cuint {.nc.}

# L892 - notcurses/notcurses.h
proc nccell_strdup*(n: ptr ncplane, c: ptr nccell): cstring {.nc.}

# L898 - notcurses/notcurses.h
proc nccell_extract*(n: ptr ncplane, c: ptr nccell, stylemask: uint16, channels: uint64): cstring {.nc.}

# L915 - notcurses/notcurses.h
proc nccellcmp*(n1: ptr ncplane, c1: ptr nccell, n2: ptr ncplane, c2: ptr nccell): bool {.nc.}

# L929 - notcurses/notcurses.h
proc nccell_load_char*(n: ptr ncplane, c: ptr nccell, ch: cchar): cint {.nc.}

# L939 - notcurses/notcurses.h
proc nccell_load_egc32*(n: ptr ncplane, c: ptr nccell, egc: uint32): cint {.nc.}

# L950 - notcurses/notcurses.h
proc nccell_load_ucs32*(n: ptr ncplane, c: ptr nccell, u: uint32): cint {.nc.}

# L1065 - notcurses/notcurses.h
proc notcurses_lex_margins*(op: cstring, opts: ptr notcurses_options): cint {.nc.}

# L1069 - notcurses/notcurses.h
proc notcurses_lex_blitter*(op: cstring, blitter: ptr ncblitter_e): cint {.nc.}

# L1073 - notcurses/notcurses.h
proc notcurses_str_blitter*(blitter: ncblitter_e): cstring {.nc.}

# L1077 - notcurses/notcurses.h
proc notcurses_lex_scalemode*(op: cstring, scalemode: ptr ncscale_e): cint {.nc.}

# L1081 - notcurses/notcurses.h
proc notcurses_str_scalemode*(scalemode: ncscale_e): cstring {.nc.}

# L1087 - notcurses/notcurses.h
proc notcurses_init*(opts: ptr notcurses_options, fp: File): ptr notcurses {.nc.}

# L1091 - notcurses/notcurses.h
proc notcurses_core_init*(opts: ptr notcurses_options, fp: File): ptr notcurses {.nc.}

# L1094 - notcurses/notcurses.h
proc notcurses_stop*(nc: ptr notcurses): cint {.nc.}

# L1100 - notcurses/notcurses.h
proc notcurses_enter_alternate_screen*(nc: ptr notcurses): cint {.nc.}

# L1105 - notcurses/notcurses.h
proc notcurses_leave_alternate_screen*(nc: ptr notcurses): cint {.nc.}

# L1111 - notcurses/notcurses.h
proc notcurses_stdplane*(nc: ptr notcurses): ptr ncplane {.nc.}

# L1113 - notcurses/notcurses.h
proc notcurses_stdplane_const*(nc: ptr notcurses): ptr ncplane {.nc.}

# L1117 - notcurses/notcurses.h
proc ncpile_top*(n: ptr ncplane): ptr ncplane {.nc.}

# L1121 - notcurses/notcurses.h
proc ncpile_bottom*(n: ptr ncplane): ptr ncplane {.nc.}

# L1126 - notcurses/notcurses.h
proc notcurses_top*(n: ptr notcurses): ptr ncplane {.nc.}

# L1132 - notcurses/notcurses.h
proc notcurses_bottom*(n: ptr notcurses): ptr ncplane {.nc.}

# L1138 - notcurses/notcurses.h
proc ncpile_render*(n: ptr ncplane): cint {.nc.}

# L1144 - notcurses/notcurses.h
proc ncpile_rasterize*(n: ptr ncplane): cint {.nc.}

# L1149 - notcurses/notcurses.h
proc notcurses_render*(nc: ptr notcurses): cint {.nc.}

# L1161 - notcurses/notcurses.h
proc ncpile_render_to_buffer*(p: ptr ncplane, buf: ptr cstring, buflen: ptr csize_t): cint {.nc.}

# L1166 - notcurses/notcurses.h
proc ncpile_render_to_file*(p: ptr ncplane, fp: File): cint {.nc.}

# L1170 - notcurses/notcurses.h
proc notcurses_drop_planes*(nc: ptr notcurses) {.nc.}

# L1190 - notcurses/notcurses.h
proc nckey_mouse_p*(r: uint32): bool {.nc.}

# L1220 - notcurses/notcurses.h
proc ncinput_shift_p*(n: ptr ncinput): bool {.nc.}

# L1225 - notcurses/notcurses.h
proc ncinput_ctrl_p*(ni: ptr ncinput): bool {.nc.}

# L1230 - notcurses/notcurses.h
proc ncinput_alt_p*(ni: ptr ncinput): bool {.nc.}

# L1235 - notcurses/notcurses.h
proc ncinput_meta_p*(ni: ptr ncinput): bool {.nc.}

# L1240 - notcurses/notcurses.h
proc ncinput_super_p*(ni: ptr ncinput): bool {.nc.}

# L1245 - notcurses/notcurses.h
proc ncinput_hyper_p*(ni: ptr ncinput): bool {.nc.}

# L1250 - notcurses/notcurses.h
proc ncinput_capslock_p*(ni: ptr ncinput): bool {.nc.}

# L1255 - notcurses/notcurses.h
proc ncinput_numlock_p*(ni: ptr ncinput): bool {.nc.}

# L1263 - notcurses/notcurses.h
proc ncinput_equal_p*(n1: ptr ncinput, n2: ptr ncinput): bool {.nc.}

# L1294 - notcurses/notcurses.h
proc notcurses_get*(n: ptr notcurses, ts: ptr Timespec, ni: ptr ncinput): uint32 {.nc.}

# L1300 - notcurses/notcurses.h
proc notcurses_getvec*(n: ptr notcurses, ts: ptr Timespec, ni: ptr ncinput, vcount: cint): cint {.nc.}

# L1308 - notcurses/notcurses.h
proc notcurses_inputready_fd*(n: ptr notcurses): cint {.nc.}

# L1314 - notcurses/notcurses.h
proc notcurses_get_nblock*(n: ptr notcurses, ni: ptr ncinput): uint32 {.nc.}

# L1322 - notcurses/notcurses.h
proc notcurses_get_blocking*(n: ptr notcurses, ni: ptr ncinput): uint32 {.nc.}

# L1328 - notcurses/notcurses.h
proc ncinput_nomod_p*(ni: ptr ncinput): bool {.nc.}

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
proc ncplane_putwc*(n: ptr ncplane, w: Wchar): cint {.nc.}

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
