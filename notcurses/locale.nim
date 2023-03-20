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

proc getLocale(category: cint, name: string): Result[string, LocaleError] =
  let loc = setlocale(category, nil)
  if loc.isNil:
    err LocaleError(msg: "setlocale failed to query " & name)
  else:
    ok $loc

macro getLocale*(category: cint): Result[string, LocaleError] =
  let name = category.strVal
  quote do: getLocale(`category`, `name`)

proc setLocale(category: cint, locale: string, name: string):
    Result[string, LocaleError] =
  let loc = setlocale(category, locale.cstring)
  if loc.isNil:
    let msg =
      if locale == "": "setlocale failed to install " & name
      else: "setlocale failed to install " & locale & " as " & name
    err LocaleError(msg: msg)
  else:
    ok $loc

macro setLocale*(category: cint, locale: string): Result[string, LocaleError] =
  let name = category.strVal
  quote do: setLocale(`category`, `locale`, `name`)
