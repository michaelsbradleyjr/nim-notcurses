# https://en.cppreference.com/w/c/locale/LC_categories
# https://en.cppreference.com/w/c/locale/setlocale

# this module uses extra whitespace so it can be visually scanned more easily

import std/macros
import pkg/stew/results

type
  Category* = distinct int32
  LocaleError* = object of CatchableError
  LocaleSuccess* = string

const FailureNotExpected = "failure not expected"

var
  LC_ALL_c      {.header: "<locale.h>", importc: "LC_ALL"     .}: cint
  LC_COLLATE_c  {.header: "<locale.h>", importc: "LC_COLLATE" .}: cint
  LC_CTYPE_c    {.header: "<locale.h>", importc: "LC_CTYPE"   .}: cint
  LC_MONETARY_c {.header: "<locale.h>", importc: "LC_MONETARY".}: cint
  LC_NUMERIC_c  {.header: "<locale.h>", importc: "LC_NUMERIC" .}: cint
  LC_TIME_c     {.header: "<locale.h>", importc: "LC_TIME"    .}: cint

  LC_ALL* = LC_ALL_c.Category
  LC_COLLATE* = LC_COLLATE_c.Category
  LC_CTYPE* = LC_CTYPE_c.Category
  LC_MONETARY* = LC_MONETARY_c.Category
  LC_NUMERIC* = LC_NUMERIC_c.Category
  LC_TIME* = LC_TIME_c.Category

when defined(posix):
  var
    LC_MESSAGES_c {.header: "<locale.h>", importc: "LC_MESSAGES".}: cint
    LC_MESSAGES* = LC_MESSAGES_c.Category

proc expect*[T: LocaleSuccess, E: LocaleError](res: Result[T, E],
    m = FailureNotExpected): T {.discardable.} =
  results.expect(res, m)

proc setlocale(category: cint, locale: cstring): cstring
  {.header: "<locale.h>", importc: "setlocale".}

proc getLocale(category: Category, name: string):
    Result[LocaleSuccess, LocaleError] =
  let loc = setlocale(category.int32, nil)
  if loc.isNil:
    err LocaleError(msg: "setlocale failed to query " & name)
  else:
    ok $loc

macro getLocale*(category: Category): Result[LocaleSuccess, LocaleError] =
  let name = category.strVal
  quote do: getLocale(`category`, `name`)

proc setLocale(category: Category, locale: string, name: string):
    Result[LocaleSuccess, LocaleError] =
  let loc = setlocale(category.int32, locale.cstring)
  if loc.isNil:
    err LocaleError(
      msg: "setlocale failed to install " & locale & " as " & name)
  else:
    ok $loc

macro setLocale*(category: Category, locale: string):
    Result[LocaleSuccess, LocaleError] =
  let name = category.strVal
  quote do: setLocale(`category`, `locale`, `name`)
