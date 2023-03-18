# https://en.cppreference.com/w/c/locale/LC_categories
# https://en.cppreference.com/w/c/locale/setlocale

import std/macros
import pkg/stew/results

type
  LocaleError* = object of CatchableError
  LocaleSuccess* = string

const
  FailureNotExpected = "failure not expected"
  loc_header = "<locale.h>"

{.pragma: loc, header: loc_header, importc, nodecl.}

var
  LC_ALL* {.loc.}: cint
  LC_COLLATE* {.loc.}: cint
  LC_CTYPE* {.loc.}: cint
  LC_MONETARY* {.loc.}: cint
  LC_NUMERIC* {.loc.}: cint
  LC_TIME* {.loc.}: cint

when defined(posix):
  var LC_MESSAGES* {.loc.}: cint

proc expect*[T: LocaleSuccess, E: LocaleError](res: Result[T, E],
    m = FailureNotExpected): T {.discardable.} =
  results.expect(res, m)

proc setlocale(category: cint, locale: cstring): cstring
  {.cdecl, header: loc_header, importc.}

proc getLocale(category: cint, name: string):
    Result[LocaleSuccess, LocaleError] =
  let loc = setlocale(category, nil)
  if loc.isNil:
    err LocaleError(msg: "setlocale failed to query " & name)
  else:
    ok $loc

macro getLocale*(category: cint): Result[LocaleSuccess, LocaleError] =
  let name = category.strVal
  quote do: getLocale(`category`, `name`)

proc setLocale(category: cint, locale: string, name: string):
    Result[LocaleSuccess, LocaleError] =
  let loc = setlocale(category, locale.cstring)
  if loc.isNil:
    let msg =
      if locale == "": "setlocale failed to install " & name
      else: "setlocale failed to install " & locale & " as " & name
    err LocaleError(msg: msg)
  else:
    ok $loc

macro setLocale*(category: cint, locale: string):
    Result[LocaleSuccess, LocaleError] =
  let name = category.strVal
  quote do: setLocale(`category`, `locale`, `name`)
