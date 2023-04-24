# https://en.cppreference.com/w/c/locale/LC_categories
# https://en.cppreference.com/w/c/locale/setlocale

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

const loc_header = "<locale.h>"
{.pragma: loc, header: loc_header, importc, nodecl.}

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  let
    LC_ALL* {.loc.}: cint
    LC_COLLATE* {.loc.}: cint
    LC_CTYPE* {.loc.}: cint
    LC_MONETARY* {.loc.}: cint
    LC_NUMERIC* {.loc.}: cint
    LC_TIME* {.loc.}: cint
  when defined(posix):
    let LC_MESSAGES* {.loc.}: cint
else:
  var
    LC_ALL* {.loc.}: cint
    LC_COLLATE* {.loc.}: cint
    LC_CTYPE* {.loc.}: cint
    LC_MONETARY* {.loc.}: cint
    LC_NUMERIC* {.loc.}: cint
    LC_TIME* {.loc.}: cint
  when defined(posix):
    var LC_MESSAGES* {.loc.}: cint

proc setlocale*(category: cint, locale: cstring): cstring {.cdecl, header: loc_header, importc.}
