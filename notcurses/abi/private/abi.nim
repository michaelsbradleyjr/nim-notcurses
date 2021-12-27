const
  notcurses_header: string = NotcursesHeader
  notcurses_import_prefix: string = NotcursesImportPrefix
  notcurses_init_name = notcurses_import_prefix & "init"
  notcurses_lib: string = NotcursesLib

type
  ncinput {.bycopy, header: notcurses_header,
    importc: "struct ncinput".} = object

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

proc notcurses_init(opts: ptr notcurses_options, fp: File): ptr notcurses
  {.cdecl, dynlib: notcurses_lib, importc: notcurses_init_name.}

proc notcurses_render(nc: ptr notcurses): cint
  {.cdecl, header: notcurses_header, importc.}

proc notcurses_stdplane(nc: ptr notcurses): ptr ncplane
  {.cdecl, dynlib: notcurses_lib, importc.}

proc notcurses_stop(nc: ptr notcurses): cint
  {.cdecl, dynlib: notcurses_lib, importc.}
