const
  notcurses_header: string = NotcursesHeader
  notcurses_import_prefix: string = NotcursesImportPrefix
  notcurses_init_name = notcurses_import_prefix & "init"
  notcurses_lib: string = NotcursesLib

type
  ncplane {.header: notcurses_header, importc: "struct ncplane".} = object

  notcurses {.header: notcurses_header, importc: "struct notcurses",
    incompleteStruct.} = object

  notcurses_options {.bycopy, header: notcurses_header,
    importc: "struct notcurses_options".} = object
    flags*: culonglong

proc ncpile_rasterize(n: ptr ncplane): cint
  {.cdecl, discardable, dynlib: notcurses_lib, importc.}

proc ncpile_render(n: ptr ncplane): cint
  {.cdecl, discardable, dynlib: notcurses_lib, importc.}

proc notcurses_init(opts: ptr notcurses_options, fp: File):
  ptr notcurses {.cdecl, dynlib: notcurses_lib, importc: notcurses_init_name.}

proc notcurses_render(nc: ptr notcurses): cint
  {.cdecl, discardable, dynlib: notcurses_lib, header: notcurses_header,
  importc.}

proc notcurses_stdplane(nc: ptr notcurses): ptr ncplane
  {.cdecl, dynlib: notcurses_lib, importc.}

proc notcurses_stop(nc: ptr notcurses): cint
  {.cdecl, discardable, dynlib: notcurses_lib, importc.}
