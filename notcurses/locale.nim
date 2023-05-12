when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/macros
import pkg/stew/results
import ./abi/locale

export results

type
  Category* = distinct int32
  LocaleError* = object of CatchableError

let
  LC_ALL* = Category(LC_ALL)
  LC_COLLATE* = Category(LC_COLLATE)
  LC_CTYPE* = Category(LC_CTYPE)
  LC_MONETARY* = Category(LC_MONETARY)
  LC_NUMERIC* = Category(LC_NUMERIC)
  LC_TIME* = Category(LC_TIME)
when defined(posix):
  let LC_MESSAGES* = Category(LC_MESSAGES)

const FailureNotExpected = "failure not expected"

proc expect*[T: string, E: LocaleError](res: Result[T, E],
    m = FailureNotExpected): T {.discardable.} =
  results.expect(res, m)

proc getLocale*(category: Category, name: string): Result[string, LocaleError] =
  let loc = setlocale(category.int32, nil)
  if loc.isNil:
    err LocaleError(msg: "setlocale failed to query " & name)
  else:
    ok $loc

macro getLocale*(category: Category): Result[string, LocaleError] =
  let name = category.strVal
  quote do: getLocale(`category`, `name`)

proc setLocale*(category: Category, locale: string, name: string):
    Result[string, LocaleError] =
  let loc = setlocale(category.int32, locale.cstring)
  if loc.isNil:
    let msg =
      if locale == "":
        "setlocale failed to install the user-preferred locale as " & name
      else:
        "setlocale failed to install " & locale & " as " & name
    err LocaleError(msg: msg)
  else:
    ok $loc

macro setLocale*(category: Category, locale: string): Result[string, LocaleError] =
  let name = category.strVal
  quote do: setLocale(`category`, `locale`, `name`)
