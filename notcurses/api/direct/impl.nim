when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[atomics, bitops]
import pkg/stew/results
import ../../abi/direct/impl
import ../common
import ./constants

export common except ApiDefect, isNcInited, isNcdInited, setNcInited,
  setNcIniting, setNcStopped, setNcStopping, setNcdInited, setNcdIniting,
  setNcdStopped, setNcdStopping
export constants except AllKeys, DefectMessages

type
  Channel = common.Channel

  ErrorMessages {.pure.} = enum
    PutStr = "ncdirect_putstr failed"
    SetStyles = "ncdirect_set_styles failed"

  InitProc = proc (t: cstring, f: File, flags: uint64): ptr ncdirect {.cdecl.}

  NotcursesDirect* = object
    cPtr: ptr ncdirect

  Options* = object
    flags*: uint64
    term*: string

  # Aliases
  Ncd* = NotcursesDirect
  NcdOptions* = Options

var
  ncdApiObj {.threadvar.}: NotcursesDirect
  ncdExitProcAdded: Atomic[bool]
  ncdInit: InitProc
  ncdPtr: Atomic[ptr ncdirect]

proc get*(T: type NotcursesDirect): T =
  if not isNcdInited():
    raise (ref ApiDefect)(msg: $NotcursesDirectNotInitialized)
  ncdApiObj

func init*(T: type Options, initOptions: openArray[InitOptions] = [],
    term = ""): T =
  var flags = 0'u64
  for o in initOptions[0..^1]:
    flags = bitor(flags, o.uint64)
  T(flags: flags, term: term)

proc putStr*(ncd: NotcursesDirect, s: string, channel = Channel(0)):
    Result[ApiSuccess, ApiErrorCode] =
  let code = ncd.cPtr.ncdirect_putstr(channel.uint64, s.cstring)
  if code < 0:
    err ApiErrorCode(code: code, msg: $PutStr)
  else:
    ok code

proc setNcdInit*() =
  if ncdInit.isNil: ncdInit = ncdirect_init
  elif ncdInit != ncdirect_init:
    let msg =
      "cannot set init proc as ncdirect_init when it is already set as " &
      "ncdirect_core_init"
    raise (ref ApiDefect)(msg: msg)

proc setNcdCoreInit*() =
  if ncdInit.isNil: ncdInit = ncdirect_core_init
  elif ncdInit != ncdirect_core_init:
    let msg =
      "cannot set init proc as ncdirect_core_init when it is already set as " &
      "ncdirect_init"
    raise (ref ApiDefect)(msg: msg)

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
  setNcdStopping()
  if ncd.cPtr.ncdirect_stop < 0:
    raise (ref ApiDefect)(msg: $NotcursesDirectFailedToStop)
  else:
    ncdPtr.store(nil)
    ncdApiObj = NotcursesDirect()
    setNcdStopped()

proc stopNotcurses() {.noconv.} = NotcursesDirect.get.stop

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  import std/exitprocs
  template addExitProc(T: type NotcursesDirect) =
    if not ncdExitProcAdded.exchange(true): addExitProc stopNotcurses
else:
  template addExitProc(T: type NotcursesDirect) =
    if not ncdExitProcAdded.exchange(true): addQuitProc stopNotcurses

proc init*(T: type NotcursesDirect, options = Options.init, file = stdout,
    addExitProc = true): T =
  setNcdIniting()
  if ncdInit.isNil: raise (ref Defect)(msg: $NotcursesDirectInitNotSet)
  var cPtr: ptr ncdirect
  var termtype: cstring
  if options.term != "": termtype = options.term.cstring
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: off.}
  try:
    cPtr = ncdInit(termtype, file, options.flags)
  except Exception:
    raise (ref ApiDefect)(msg: $NotcursesDirectFailedToInitialize)
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: on.}
  if cPtr.isNil: raise (ref ApiDefect)(msg: $NotcursesDirectFailedToInitialize)
  ncdApiObj = T(cPtr: cPtr)
  ncdPtr.store cPtr
  if addExitProc:
    when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
      {.warning[BareExcept]: off.}
    try:
      T.addExitProc
    except Exception as e:
      var msg = $AddExitProcFailed
      if e.msg != "":
        msg = msg & " with message \"" & e.msg & "\""
      raise (ref ApiDefect)(msg: msg)
    when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
      {.warning[BareExcept]: on.}
  setNcdInited()
  ncdApiObj

func supportedStyles*(ncd: NotcursesDirect): uint16 =
  ncd.cPtr.ncdirect_supported_styles
