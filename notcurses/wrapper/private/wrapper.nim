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

const
  NCOPTION_DRAIN_INPUT         = 0x0000000000000100.culonglong
  NCOPTION_INHIBIT_SETLOCALE   = 0x0000000000000001.culonglong
  NCOPTION_NO_ALTERNATE_SCREEN = 0x0000000000000040.culonglong
  NCOPTION_NO_CLEAR_BITMAPS    = 0x0000000000000002.culonglong
  NCOPTION_NO_FONT_CHANGES     = 0x0000000000000080.culonglong
  NCOPTION_NO_QUIT_SIGHANDLERS = 0x0000000000000008.culonglong
  NCOPTION_NO_WINCH_SIGHANDLER = 0x0000000000000004.culonglong
  NCOPTION_PRESERVE_CURSOR     = 0x0000000000000010.culonglong
  NCOPTION_SUPPRESS_BANNERS    = 0x0000000000000020.culonglong

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
