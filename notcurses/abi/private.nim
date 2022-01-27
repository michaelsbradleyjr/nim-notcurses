type
  AbiDefect = object of Defect

  wchar_t {.importc.} = object

const
  nc_header = "notcurses/notcurses.h"
  nc_init_name = nc_init_prefix & "init"

{.pragma: nc, cdecl, dynlib: nc_lib, importc.}
{.pragma: nc_bycopy, bycopy, header: nc_header.}
{.pragma: nc_incomplete, header: nc_header, incompleteStruct.}
{.pragma: nc_init, cdecl, dynlib: nc_init_lib, importc: nc_init_name.}

# L187 notcurses/nckeys.h
func nckey_synthesized_p(w: uint32): bool =
  w >= PRETERUNICODEBASE and w <= NCKEY_EOF

# L201 notcurses/nckeys.h
func nckey_pua_p     (w: uint32): bool = w >= 0x0000e000 and w <= 0x0000f8ff

# L207 notcurses/nckeys.h
func nckey_supppuaa_p(w: uint32): bool = w >= 0x000f0000 and w <= 0x000ffffd

# L213 notcurses/nckeys.h
func nckey_supppuab_p(w: uint32): bool = w >= 0x00100000 and w <= 0x0010fffd

# L39 - notcurses/notcurses.h
proc notcurses_version(): cstring {.nc.}

# L42 - notcurses/notcurses.h
proc notcurses_version_components(major, minor, patch, tweak: ptr cint) {.nc.}

type
  # L44 - notcurses/notcurses.h
  notcurses       {.nc_incomplete, importc: "struct notcurses"      .} = object
  ncplane         {.nc_incomplete, importc: "struct ncplane"        .} = object
  ncvisual        {.nc_incomplete, importc: "struct ncvisual"       .} = object
  ncuplot         {.nc_incomplete, importc: "struct ncuplot"        .} = object
  ncdplot         {.nc_incomplete, importc: "struct ncdplot"        .} = object
  ncprogbar       {.nc_incomplete, importc: "struct ncprogbar"      .} = object
  ncfdplane       {.nc_incomplete, importc: "struct ncfdplane"      .} = object
  ncsubproc       {.nc_incomplete, importc: "struct ncsubproc"      .} = object
  ncselector      {.nc_incomplete, importc: "struct ncselector"     .} = object
  ncmultiselector {.nc_incomplete, importc: "struct ncmultiselector".} = object
  ncreader        {.nc_incomplete, importc: "struct ncreader"       .} = object
  ncfadectx       {.nc_incomplete, importc: "struct ncfadectx"      .} = object
  nctablet        {.nc_incomplete, importc: "struct nctablet"       .} = object
  ncreel          {.nc_incomplete, importc: "struct ncreel"         .} = object
  nctab           {.nc_incomplete, importc: "struct nctab"          .} = object
  nctabbed        {.nc_incomplete, importc: "struct nctabbed"       .} = object
  ncdirect        {.nc_incomplete, importc: "struct ncdirect"       .} = object

  # L982 - notcurses/notcurses.h
  notcurses_options {.nc_bycopy, importc: "struct notcurses_options".} = object
    termtype*: cstring
    loglevel*: ncloglevel_e
    margin_t*: cuint
    margin_r*: cuint
    margin_b*: cuint
    margin_l*: cuint
    flags*   : culonglong

# L1026, L1030 - notcurses/notcurses.h
proc notcurses_init(opts: ptr notcurses_options, fp: File): ptr notcurses
  {.nc_init.}

# L1033 - notcurses/notcurses.h
proc notcurses_stop(nc: ptr notcurses): cint {.nc.}

# L1050 - notcurses/notcurses.h
proc notcurses_stdplane(nc: ptr notcurses): ptr ncplane {.nc.}

# L1077 - notcurses/notcurses.h
proc ncpile_render(n: ptr ncplane): cint {.nc.}

# L1083 - notcurses/notcurses.h
proc ncpile_rasterize(n: ptr ncplane): cint {.nc.}

# L1088 - notcurses/notcurses.h
proc notcurses_render(nc: ptr notcurses): cint {.nc.}

type
  # L1144 - notcurses/notcurses.h
  ncinput {.nc_bycopy, importc: "struct ncinput".} = object
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

# L1261 - notcurses/notcurses.h
proc notcurses_get_blocking(n: ptr notcurses, ni: ptr ncinput): uint32 {.nc.}

# L1315 - notcurses/notcurses.h
proc ncplane_dim_yx(n: ptr ncplane, y, x: ptr cuint) {.nc.}

# L1326 - notcurses/notcurses.h
proc notcurses_stddim_yx(nc: ptr notcurses, y, x: ptr cuint): ptr ncplane {.nc.}

# L1501 - notcurses/notcurses.h
proc ncplane_set_scrolling(n: ptr ncplane, scrollp: cuint): bool {.nc.}

# L2225 - notcurses/notcurses.h
proc ncplane_putstr(n: ptr ncplane, gclustarr: cstring): cint {.nc.}

# L2371 - notcurses/notcurses.h
proc ncplane_putwc(n: ptr ncplane, w: wchar_t): cint {.nc.}

# L2850 - notcurses/notcurses.h
proc ncplane_set_styles(n: ptr ncplane, stylebits: cuint) {.nc.}

var
  lib_notcurses_major: cint
  lib_notcurses_minor: cint
  lib_notcurses_patch: cint
  lib_notcurses_tweak: cint

notcurses_version_components(addr lib_notcurses_major, addr lib_notcurses_minor,
  addr lib_notcurses_patch, addr lib_notcurses_tweak)

if nim_notcurses_version.major != lib_notcurses_major:
  raise (ref AbiDefect)(msg: "nim-notcurses major version " &
    $nim_notcurses_version.major &
    " is not compatible with Notcurses library major version " &
    $lib_notcurses_major & " (nim-notcurses: " & $nim_notcurses_version.major &
    "." & $nim_notcurses_version.minor & "." & $nim_notcurses_version.patch &
    ", libnotcurses: " & $notcurses_version() & ")")
