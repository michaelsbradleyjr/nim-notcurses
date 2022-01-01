const
  notcurses_header: string = NotcursesHeader
  notcurses_import_prefix: string = NotcursesImportPrefix
  notcurses_init_name = notcurses_import_prefix & "init"
  notcurses_lib: string = NotcursesLib

# move constants up in include of abi builder encode the NC_TYPE values as
# const cint here build an enum with the same named 'evtype', but maybe not
# export it?  in the api modules will also need corresponding enum using the
# same constants but named 'NcType' and should be distinct c/int will it work
# out?... or maybe here can just use cint here in the abi and have proper enum
# in the api

include ./private/constants

type
  ncinput {.bycopy, header: notcurses_header,
      importc: "struct ncinput".} = object
    evtype*: cint
    id*: uint32

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
