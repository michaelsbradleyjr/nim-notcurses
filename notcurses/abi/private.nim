type NotcursesDefect = object of Defect

const
  notcurses_header = "notcurses/notcurses.h"
  notcurses_init_name = notcurses_init_import_prefix & "init"

proc notcurses_version_components(major, minor, patch, tweak: ptr cint)
  {.cdecl, dynlib: notcurses_lib, importc.}

var notcurses_major, notcurses_minor, notcurses_patch, notcurses_tweak: cint

notcurses_version_components(addr notcurses_major, addr notcurses_minor,
  addr notcurses_patch, addr notcurses_tweak)

if nim_notcurses_version.major != notcurses_major:
  raise (ref NotcursesDefect)(msg:
    "nim-notcurses major version " & $nim_notcurses_version.major & " " &
    "is not compatible with Notcurses library major version " &
    $notcurses_major)

type
  ncinput {.bycopy, header: notcurses_header,
      importc: "struct ncinput".} = object
    alt*, ctrl*, shift*: bool
    evtype*: NCTYPES
    id*: uint32
    utf8*: array[5, cchar]
    x*, xpx*, y*, ypx*: cint

  ncplane {.header: notcurses_header, importc: "struct ncplane",
    incompleteStruct.} = object

  notcurses {.header: notcurses_header, importc: "struct notcurses",
    incompleteStruct.} = object

  notcurses_options {.bycopy, header: notcurses_header,
      importc: "struct notcurses_options".} = object
    flags*: culonglong

proc ncpile_rasterize(n: ptr ncplane): cint
  {.cdecl, dynlib: notcurses_lib, importc.}

proc ncpile_render(n: ptr ncplane): cint
  {.cdecl, dynlib: notcurses_lib, importc.}

proc ncplane_putstr(n: ptr ncplane, gclustarr: cstring): cint
  {.cdecl, header: notcurses_header, importc.}

proc ncplane_set_scrolling(n: ptr ncplane, scrollp: cuint): bool
  {.cdecl, dynlib: notcurses_lib, importc.}

proc notcurses_get_blocking(n: ptr notcurses; ni: ptr ncinput): uint32
  {.cdecl, header: notcurses_header, importc.}

proc notcurses_init(opts: ptr notcurses_options, fp: File): ptr notcurses
  {.cdecl, dynlib: notcurses_lib, importc: notcurses_init_name.}

proc notcurses_render(nc: ptr notcurses): cint
  {.cdecl, header: notcurses_header, importc.}

proc notcurses_stdplane(nc: ptr notcurses): ptr ncplane
  {.cdecl, dynlib: notcurses_lib, importc.}

proc notcurses_stop(nc: ptr notcurses): cint
  {.cdecl, dynlib: notcurses_lib, importc.}

proc notcurses_version(): cstring
  {.cdecl, dynlib: notcurses_lib, importc.}
