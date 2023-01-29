when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[atomics, bitops, options]

import pkg/stew/[byteutils, results]

export byteutils, options, results, wchar_t

type
  Direct* = object
    abiPtr: ptr ncdirect

  DirectApiDefect* = object of Defect

  DirectApiError* = object of CatchableError

  # DirectApiError0* = object of DirectApiError
  #   code*: range[low(cint).int..0]

  DirectApiErrorNeg* = object of DirectApiError
    code*: range[low(cint).int..(-1)]

  DirectApiSuccess* = object of RootObj

  DirectApiSuccess0* = object of DirectApiSuccess
    code*: range[0..high(cint).int]

  # DirectApiSuccessPos* = object of DirectApiSuccess
  #   code*: range[1..high(cint).int]

  DirectChannel* = distinct uint64

  DirectOptions* = object
    flags: uint64
    term: string

const
  NimNotcursesMajor* = nim_notcurses_version.major.int
  NimNotcursesMinor* = nim_notcurses_version.minor.int
  NimNotcursesPatch* = nim_notcurses_version.patch.int

var
  lib_notcurses_major: cint
  lib_notcurses_minor: cint
  lib_notcurses_patch: cint
  lib_notcurses_tweak: cint

notcurses_version_components(addr lib_notcurses_major, addr lib_notcurses_minor,
  addr lib_notcurses_patch, addr lib_notcurses_tweak)

let
  LibNotcursesMajor* = lib_notcurses_major.int
  LibNotcursesMinor* = lib_notcurses_minor.int
  LibNotcursesPatch* = lib_notcurses_patch.int
  LibNotcursesTweak* = lib_notcurses_tweak.int

var
  ncdAbiPtr: Atomic[ptr ncdirect]
  ncdApiObject {.threadvar.}: Direct
  ncdExitProcAdded: Atomic[bool]
  ncdStopped: Atomic[bool]

proc expect*[T: DirectApiSuccess | bool, E: DirectApiError](res: Result[T, E]):
    T {.discardable.} =
  expect(res, $DirectFailureNotExpected)

proc expect*[E: DirectApiError](res: Result[void, E]) =
  expect(res, $DirectFailureNotExpected)

proc get*(T: type Direct): T =
  if ncdApiObject.abiPtr.isNil:
    let abiPtr = ncdAbiPtr.load
    if abiPtr.isNil:
      raise (ref DirectApiDefect)(msg: $DirectNotInitialized)
    else:
      ncdApiObject = T(abiPtr: abiPtr)
  ncdApiObject

func init*(T: type DirectChannel, r, g, b: int32): T =
  NCCHANNEL_INITIALIZER(r, g, b).T

func init*(T: type DirectChannel, fr, fg, fb, br, bg, bb: int32): T =
  NCCHANNELS_INITIALIZER(fr, fg, fb, br, bg, bb).T

func init*(T: type DirectOptions, initOptions: varargs[DirectInitOptions],
    term = ""): T =
  var flags = 0'u64
  if initOptions.len >= 1:
    for o in initOptions[0..^1]:
      flags = bitor(flags, o.uint64)
  T(flags: flags, term: term)

proc putStr*(direct: Direct, s: string, channel = 0.DirectChannel):
    Result[DirectApiSuccess0, DirectApiErrorNeg] =
  let code = direct.abiPtr.ncdirect_putstr(channel.uint64, s.cstring)
  if code < 0:
    err DirectApiErrorNeg(code: code.int, msg: $DirectPutStr)
  else:
    ok DirectApiSuccess0(code: code.int)

proc stop*(direct: Direct): Result[void, DirectApiErrorNeg] =
  if ncdStopped.load: raise (ref DirectApiDefect)(msg: $DirectAlreadyStopped)
  let code = direct.abiPtr.ncdirect_stop
  if code < 0:
    err DirectApiErrorNeg(code: code.int, msg: $DirectStop)
  elif ncdStopped.exchange(true):
    raise (ref DirectApiDefect)(msg: $DirectAlreadyStopped)
  else:
    ok()

proc stopDirect() {.noconv.} = Direct.get.stop.expect

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  import std/exitprocs
  template addExitProc*(T: type Direct) =
    if not ncdExitProcAdded.exchange(true): addExitProc stopDirect
else:
  template addExitProc*(T: type Direct) =
    if not ncdExitProcAdded.exchange(true): addQuitProc stopDirect

proc init*(T: type Direct, options = DirectOptions.init, file: File = stdout,
    addExitProc = true): T =
  if not ncdApiObject.abiPtr.isNil or not ncdAbiPtr.load.isNil:
    raise (ref DirectApiDefect)(msg: $DirectAlreadyInitialized)
  else:
    # it became necessary re: recent commits in Nim's version-1-6 and
    # version-2-0 branches to here use `ptr abi.ncdirect` or
    # `ptr core.ncdirect` instead of `ptr ncdirect` (latter is used elsewhere
    # in this module); seems like a compiler bug; regardless, happily, the
    # change is compatible with older versions of Nim
    when compiles(abi.ncdirect):
      var abiPtr: ptr abi.ncdirect
    else:
      var abiPtr: ptr core.ncdirect
    var term: cstring
    when (NimMajor, NimMinor, NimPatch) < (1, 6, 0):
      if options.term != "": term = options.term.cstring
      try:
        abiPtr = abiInit(term, file, options.flags)
      except Exception:
        raise (ref DirectApiDefect)(msg: $DirectFailedToInitialize)
    else:
      abiPtr = abiInit(term, file, options.flags)
    if abiPtr.isNil: raise (ref DirectApiDefect)(msg: $DirectFailedToInitialize)
    ncdApiObject = T(abiPtr: abiPtr)
    if not ncdAbiPtr.exchange(ncdApiObject.abiPtr).isNil:
      raise (ref DirectApiDefect)(msg: $DirectAlreadyInitialized)
    if addExitProc:
      when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
        {.warning[BareExcept]: off.}
      try:
        T.addExitProc
      except Exception as e:
        var msg = $DirectAddExitProcFailed
        if e.msg != "":
          msg = msg & " with message \"" & e.msg & "\""
        raise (ref DirectApiDefect)(msg: msg)
      when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
        {.warning[BareExcept]: on.}
    ncdApiObject

# Aliases
type
  Ncd* = Direct
  NcdChannel* = DirectChannel
  NcdOptions* = DirectOptions
