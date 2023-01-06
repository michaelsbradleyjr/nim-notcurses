# https://en.cppreference.com/w/c/locale/LC_categories
# https://en.cppreference.com/w/c/locale/setlocale

import std/macros

import pkg/stew/results

type
  Category* = distinct cint

  LocaleError* = object of CatchableError

  LocaleSuccess* = string

const FailureNotExpected = "failure not expected"

let
  LC_ALL_c      {.header: "<locale.h>", importc: "LC_ALL"     .}: cint
  LC_COLLATE_c  {.header: "<locale.h>", importc: "LC_COLLATE" .}: cint
  LC_CTYPE_c    {.header: "<locale.h>", importc: "LC_CTYPE"   .}: cint
  LC_MONETARY_c {.header: "<locale.h>", importc: "LC_MONETARY".}: cint
  LC_NUMERIC_c  {.header: "<locale.h>", importc: "LC_NUMERIC" .}: cint
  LC_TIME_c     {.header: "<locale.h>", importc: "LC_TIME"    .}: cint

  LC_ALL*      = LC_ALL_c.Category
  LC_COLLATE*  = LC_COLLATE_c.Category
  LC_CTYPE*    = LC_CTYPE_c.Category
  LC_MONETARY* = LC_MONETARY_c.Category
  LC_NUMERIC*  = LC_NUMERIC_c.Category
  LC_TIME*     = LC_TIME_c.Category

when defined(posix):
  let
    LC_MESSAGES_c {.header: "<locale.h>", importc: "LC_MESSAGES".}: cint

    LC_MESSAGES* = LC_MESSAGES_c.Category

proc expect*[T: LocaleSuccess, E: LocaleError](res: Result[T, E]): T
    {.discardable.} =
  expect(res, FailureNotExpected)

proc setlocale(category: cint, locale: cstring): cstring
  {.importc: "setlocale", header: "<locale.h>".}

proc getLocale(category: Category, categoryName: string):
    Result[LocaleSuccess, LocaleError] =
  let loc = setlocale(category.cint, nil)
  if loc.isNil:
    err LocaleError(msg: "setlocale failed to query " & categoryName & "!")
  else:
    ok $loc

macro getLocale*(category: Category): Result[LocaleSuccess, LocaleError] =
  let categoryName = category.strVal
  quote do: getLocale(`category`, `categoryName`)

proc setLocale(category: Category, locale: string, categoryName: string):
    Result[LocaleSuccess, LocaleError] =
  let loc = setlocale(category.cint, locale.cstring)
  if loc.isNil:
    err LocaleError(msg: "setlocale failed to install " & locale & " as " &
      categoryName & "!")
  else:
    ok $loc

macro setLocale*(category: Category, locale: string):
    Result[LocaleSuccess, LocaleError] =
  let categoryName = category.strVal
  quote do: setLocale(`category`, `locale`, `categoryName`)
