type AbiDefect = object of Defect

const
  nc_header = "notcurses/notcurses.h"
  nc_init_name = notcurses_init_prefix & "init"

{.pragma: nc, cdecl, dynlib: notcurses_lib, importc.}

{.pragma: nc_bycopy, bycopy, header: nc_header.}

{.pragma: nc_incomplete, header: nc_header, incompleteStruct.}

{.pragma: nc_init, cdecl, dynlib: notcurses_init_lib, importc: nc_init_name.}

proc notcurses_version_components(major, minor, patch, tweak: ptr cint) {.nc.}

var
  lib_notcurses_major: cint
  lib_notcurses_minor: cint
  lib_notcurses_patch: cint
  lib_notcurses_tweak: cint

notcurses_version_components(addr lib_notcurses_major, addr lib_notcurses_minor,
  addr lib_notcurses_patch, addr lib_notcurses_tweak)

if nim_notcurses_version.major != lib_notcurses_major:
  raise (ref AbiDefect)(msg: "nim-notcurses major version " &
    $nim_notcurses_version.major & " " &
    "is not compatible with Notcurses library major version " &
    $lib_notcurses_major)

type
  ncinput {.nc_bycopy, importc: "struct ncinput".} = object
    id*: uint32
    y*: cint
    x*: cint
    utf8*: array[5, cchar]
    alt*: bool
    shift*: bool
    ctrl*: bool
    evtype*: NCTYPE
    modifiers*: cuint
    ypx*: cint
    xpx*: cint

  ncplane {.nc_incomplete, importc: "struct ncplane".} = object

  notcurses {.nc_incomplete, importc: "struct notcurses".} = object

  notcurses_options {.nc_bycopy, importc: "struct notcurses_options".} = object
    termtype*: cstring
    loglevel*: ncloglevel_e
    margin_t*: cuint
    margin_r*: cuint
    margin_b*: cuint
    margin_l*: cuint
    flags*: culonglong

proc ncpile_rasterize(n: ptr ncplane): cint {.nc.}

proc ncpile_render(n: ptr ncplane): cint {.nc.}

proc ncplane_putstr(n: ptr ncplane, gclustarr: cstring): cint {.nc.}

proc ncplane_set_scrolling(n: ptr ncplane, scrollp: cuint): bool {.nc.}

proc notcurses_get_blocking(n: ptr notcurses; ni: ptr ncinput): uint32 {.nc.}

proc notcurses_init(opts: ptr notcurses_options, fp: File): ptr notcurses
  {.nc_init.}

proc notcurses_render(nc: ptr notcurses): cint {.nc.}

proc notcurses_stdplane(nc: ptr notcurses): ptr ncplane {.nc.}

proc notcurses_stop(nc: ptr notcurses): cint {.nc.}

proc notcurses_version(): cstring {.nc.}
