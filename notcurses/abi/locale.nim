# https://en.cppreference.com/w/c/locale/LC_categories
# https://en.cppreference.com/w/c/locale/setlocale

# this module uses extra whitespace so it can be visually scanned more easily

const loc_header = "<locale.h>"
{.pragma: loc, header: loc_header, importc, nodecl.}

# can be `let` instead of `var` with recent enough releases of Nim 1.4+
var
  LC_ALL*      {.loc.}: cint
  LC_COLLATE*  {.loc.}: cint
  LC_CTYPE*    {.loc.}: cint
  LC_MONETARY* {.loc.}: cint
  LC_NUMERIC*  {.loc.}: cint
  LC_TIME*     {.loc.}: cint

when defined(posix):
  var LC_MESSAGES* {.loc.}: cint

proc setlocale*(category: cint, locale: cstring): cstring {.cdecl, header: loc_header, importc.}
