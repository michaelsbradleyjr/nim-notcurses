when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/macros
import pkg/stew/results
import ./abi/locale

export locale except setlocale
export results

type LocaleError* = object of CatchableError

const FailureNotExpected = "failure not expected"

proc expect*[T: string, E: LocaleError](res: Result[T, E],
    m = FailureNotExpected): T {.discardable.} =
  results.expect(res, m)

proc getLocale(category: int32, name: string): Result[string, LocaleError] =
  let loc = setlocale(category, nil)
  if loc.isNil:
    err LocaleError(msg: "setlocale failed to query " & name)
  else:
    ok $loc

macro getLocale*(category: int32): Result[string, LocaleError] =
  let name = category.strVal
  quote do: getLocale(`category`, `name`)

proc setLocale(category: int32, locale: string, name: string):
    Result[string, LocaleError] =
  let loc = setlocale(category, locale.cstring)
  if loc.isNil:
    let msg =
      if locale == "":
        "setlocale failed to install the user-preferred locale as " & name
      else:
        "setlocale failed to install " & locale & " as " & name
    err LocaleError(msg: msg)
  else:
    ok $loc

macro setLocale*(category: int32, locale: string): Result[string, LocaleError] =
  let name = category.strVal
  quote do: setLocale(`category`, `locale`, `name`)
