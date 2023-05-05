when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/bitops
import pkg/stew/results
import ../../abi/direct/impl
import ../common
import ./constants

export common except ApiDefect, PseudoCodepoint, contains
export constants except AllKeys, DefectMessages

type
  Channel = common.Channel

  ErrorMessages {.pure.} = enum
    PutStr = "ncdirect_putstr failed"
    SetStyles = "ncdirect_set_styles failed"

  Init = proc (term: cstring, fp: File, flags: uint64): ptr ncdirect {.cdecl.}

  NotcursesDirect* = object
    cPtr: ptr ncdirect

  Options* = object
    flags*: uint64
    term*: string

  # Aliases
  Ncd* = NotcursesDirect
  NcdOpts* = Options

func init*(T: type Options, flags: openArray[InitFlags] = [], term = ""): T =
  let iflags = @flags
  var flags = 0'u64
  for f in iflags[0..^1]:
    flags = bitor(flags, f.uint64)
  T(flags: flags, term: term)

proc init*(T: type NotcursesDirect, init: Init, options = Options.init,
    file = stdout): T =
  var
    cPtr: ptr ncdirect
    termtype: cstring
  if options.term != "": termtype = options.term.cstring
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: off.}
  try:
    cPtr = init(termtype, file, options.flags)
  except Exception:
    raise (ref ApiDefect)(msg: $NotcursesDirectFailedToInitialize)
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: on.}
  if cPtr.isNil: raise (ref ApiDefect)(msg: $NotcursesDirectFailedToInitialize)
  T(cPtr: cPtr)

proc putStr*(ncd: NotcursesDirect, s: string, channel = Channel(0)):
    Result[ApiSuccess, ApiErrorCode] =
  let code = ncd.cPtr.ncdirect_putstr(channel.uint64, s.cstring)
  if code < 0:
    err ApiErrorCode(code: code, msg: $PutStr)
  else:
    ok code

proc setStyles*(ncd: NotcursesDirect, styles: varargs[Styles]):
    Result[ApiSuccess, ApiErrorCode] =
  var stylebits = 0'u32
  for s in styles[0..^1]:
    stylebits = bitor(stylebits, s.uint32)
  let code = ncd.cPtr.ncdirect_set_styles stylebits
  if code != 0:
    err ApiErrorCode(code: code, msg: $SetStyles)
  else:
    ok code

proc stop*(ncd: NotcursesDirect) =
  if ncd.cPtr.ncdirect_stop < 0:
    raise (ref ApiDefect)(msg: $NotcursesDirectFailedToStop)

func supportedStyles*(ncd: NotcursesDirect): uint16 =
  ncd.cPtr.ncdirect_supported_styles
