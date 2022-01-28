let LC_ALL* {.header: "<locale.h>", importc.}: cint

proc setlocale*(category: cint, locale: cstring): cstring
  {.discardable, importc: "setlocale", header: "<locale.h>".}
