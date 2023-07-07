{.push raises: [].}

import std/[bitops, macros, sequtils, sets]
import pkg/results
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
    flags: uint64
    term: string

  # Aliases
  Ncd* = NotcursesDirect
  NcdOpts* = Options

func init*(T: typedesc[Options], flags: openArray[InitFlags] = [],
    term = ""): T =
  let flags = flags.foldl(bitor(a, b.uint64), 0'u64)
  T(flags: flags, term: term)

proc init*(T: typedesc[NotcursesDirect], init: Init, initName: string,
    options = Options.init, file = stdout): T =
  var
    cPtr: ptr ncdirect
    termtype: cstring
  let failedMsg = initName & " failed"
  if options.term != "": termtype = options.term.cstring
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.push warning[BareExcept]: off.}
  try:
    cPtr = init(termtype, file, options.flags)
  except Exception:
    raise (ref ApiDefect)(msg: failedMsg)
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.pop.}
  if cPtr.isNil: raise (ref ApiDefect)(msg: failedMsg)
  T(cPtr: cPtr)

macro init*(T: typedesc[NotcursesDirect], init: Init, options = Options.init,
    file = stdout): NotcursesDirect =
  let name = init.strVal
  quote do: `T`.init(`init`, `name`, `options`, `file`)

proc putStr*(ncd: NotcursesDirect, s: string, channel = Channel(0)):
    Result[ApiSuccess, ApiErrorCode] {.discardable.} =
  let code = ncd.cPtr.ncdirect_putstr(channel.uint64, s.cstring)
  if code < 0:
    err ApiErrorCode(code: code, msg: $PutStr)
  else:
    ok code

proc setStyles*(ncd: NotcursesDirect, styles: varargs[Styles]):
    Result[ApiSuccess, ApiErrorCode] {.discardable.} =
  let
    styles = styles.foldl(bitor(a, b.uint32), 0'u32)
    code = ncd.cPtr.ncdirect_set_styles styles
  if code != 0:
    err ApiErrorCode(code: code, msg: $SetStyles)
  else:
    ok code

proc stop*(ncd: NotcursesDirect) =
  if ncd.cPtr.ncdirect_stop < 0:
    raise (ref ApiDefect)(msg: $NcdStop)

# ncdirect_supported_styles returns uint16, and in e.g. Notcurses headers "16
# bits of NCSTYLE_* attributes" have specific uses, so will need to consider
# that as the Nim API layer evolves
func supportedStylesMask*(ncd: NotcursesDirect): Style =
  Style(ncd.cPtr.ncdirect_supported_styles)

func supportedStyles*(ncd: NotcursesDirect,
    mask = ncd.supportedStylesMask): HashSet[Styles] =
  var styles: HashSet[Styles]
  for s in [Styles.None, Struck, Bold, Undercurl, Underline, Italic]:
    if bitand(mask.uint32, s.uint32) == s.uint32:
      styles.incl s
  styles
