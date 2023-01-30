when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[atomics, bitops, options]

import pkg/stew/[byteutils, results]

export byteutils, options, results, wchar_t

type
  ApiDefect* = object of Defect

  ApiError* = object of CatchableError

  ApiError0* = object of ApiError
    code*: range[low(cint).int..0]

  ApiErrorNeg* = object of ApiError
    code*: range[low(cint).int..(-1)]

  ApiSuccess* = object of RootObj

  ApiSuccess0* = object of ApiSuccess
    code*: range[0..high(cint).int]

  ApiSuccessPos* = object of ApiSuccess
    code*: range[1..high(cint).int]

  Channel* = distinct uint64

  Codepoint* = distinct uint32

  # maybe PlaneDimensions if need to disambiguate re: other dimensions types
  Dimensions* = tuple[y, x: int]

  DirectOptions* = object
    flags: uint64
    term: string

  Input* = object
    # make this private again
    cObj*: ncinput

  Margins* = tuple[top, right, bottom, left: uint32]

  Notcurses* = object
    # make this private again
    cPtr*: ptr notcurses

  NotcursesDirect* = object
    cPtr: ptr ncdirect

  Options* = object
    cObj: notcurses_options

  Plane* = object
    # make this private again
    cPtr*: ptr ncplane

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
  ncPtr: Atomic[pointer]
  ncApiObj {.threadvar.}: Notcurses
  ncdApiObj {.threadvar.}: NotcursesDirect
  ncExitProcAdded: Atomic[bool]
  ncStopped: Atomic[bool]

func `$`*(codepoint: Codepoint): string = $codepoint.uint32

func `$`*(input: Input): string = $input.cObj

func `$`*(options: Options): string = $options.cObj

func codepoint*(input: Input): Codepoint = input.cObj.id.Codepoint

# if writing to y, x is one-shot, i.e. no updates over time (maybe upon
# resize?) then can use `var int` for the parameters, and in the body have
# cuint vars, then write to the argument vars (with conversion) after abi call
proc dimYX*(plane: Plane, y, x: var uint32) =
  plane.cPtr.ncplane_dim_yx(addr y, addr x)

proc dimYX*(plane: Plane): Dimensions =
  var y, x: cuint
  plane.dimYX(y, x)
  (y: y.int, x: x.int)

func event*(input: Input): InputEvents = cast[InputEvents](input.cObj.evtype)

proc expect*[T: ApiSuccess | bool, E: ApiError](res: Result[T, E]): T
    {.discardable.} =
  expect(res, $FailureNotExpected)

proc expect*[E: ApiError](res: Result[void, E]) =
  expect(res, $FailureNotExpected)

proc get*(T: type Notcurses): T =
  let cPtr = ncPtr.load
  if cPtr.isNil:
    raise (ref ApiDefect)(msg: $NotInitialized)
  elif ncApiObj.cPtr.isNil or ncApiObj.cPtr != cPtr:
    # it became necessary re: recent commits in Nim's version-1-6 and
    # version-2-0 branches to here use `ptr abi.notcurses` or
    # `ptr core.notcurses` instead of `ptr notcurses` (latter is used
    # elsewhere in this module); seems like a compiler bug; regardless,
    # happily, the change is compatible with older versions of Nim
    when compiles(abi.notcurses):
      ncApiObj = T(cPtr: cast[ptr abi.notcurses](cPtr))
    else:
      ncApiObj = T(cPtr: cast[ptr core.notcurses](cPtr))
  ncApiObj

proc get*(T: type NotcursesDirect): T =
  let cPtr = ncPtr.load
  if cPtr.isNil:
    raise (ref ApiDefect)(msg: $NotInitialized)
  elif ncdApiObj.cPtr.isNil or ncdApiObj.cPtr != cPtr:
    # it became necessary re: recent commits in Nim's version-1-6 and
    # version-2-0 branches to here use `ptr abi.ncdirect` or
    # `ptr core.ncdirect` instead of `ptr ncdirect` (latter is used elsewhere
    # in this module); seems like a compiler bug; regardless, happily, the
    # change is compatible with older versions of Nim
    when compiles(abi.notcurses):
      ncdApiObj = T(cPtr: cast[ptr abi.ncdirect](cPtr))
    else:
      ncdApiObj = T(cPtr: cast[ptr core.ncdirect](cPtr))
  ncdApiObj

# when implementing api for notcurses_get, etc. (i.e. the abi calls that return
# 0.uint32 on timeout), use Option none for timeout and Option some
# NotcursesCodepoint otherwise

proc getBlocking*(nc: Notcurses, input: var Input) =
  discard nc.cPtr.notcurses_get_blocking(unsafeAddr input.cObj)

func init*(T: type Channel, r, g, b: int32): T =
  NCCHANNEL_INITIALIZER(r, g, b).T

func init*(T: type Channel, fr, fg, fb, br, bg, bb: int32): T =
  NCCHANNELS_INITIALIZER(fr, fg, fb, br, bg, bb).T

func init*(T: type Margins, top, right, bottom, left = 0'u32): T =
  (top: top.uint32, right: right.uint32, bottom: bottom.uint32,
   left: left.uint32)

func init*(T: type Options, initOptions: varargs[InitOptions], term = "",
    logLevel = LogLevels.Panic, margins = Margins.init): T =
  var flags = baseInitOption.uint64
  if initOptions.len >= 1:
    for o in initOptions[0..^1]:
      flags = bitor(flags, o.uint64)
  if term == "":
    T(cObj: notcurses_options(loglevel: cast[ncloglevel_e](logLevel),
      margin_t: margins.top.cuint, margin_r: margins.right.cuint,
      margin_b: margins.bottom.cuint, margin_l: margins.left.cuint,
      flags: flags))
  else:
    T(cObj: notcurses_options(termtype: term.cstring,
      loglevel: cast[ncloglevel_e](logLevel), margin_t: margins.top.cuint,
      margin_r: margins.right.cuint, margin_b: margins.bottom.cuint,
      margin_l: margins.left.cuint, flags: flags))

func init*(T: type DirectOptions, initOptions: varargs[DirectInitOptions],
    term = ""): T =
  var flags = 0'u64
  if initOptions.len >= 1:
    for o in initOptions[0..^1]:
      flags = bitor(flags, o.uint64)
  T(flags: flags, term: term)

func init*(T: type Input): T = T(cObj: ncinput())

proc getBlocking*(nc: Notcurses): Input =
  var input = Input.init
  nc.getBlocking input
  input

func getScrolling*(plane: Plane): bool = plane.cPtr.ncplane_scrolling_p

proc gradient*(plane: Plane, y, x: int, ylen, xlen: uint, ul, ur, ll,
    lr: Channel, egc = "", styles: varargs[Styles]):
    Result[ApiSuccess0, ApiErrorNeg] =
  var stylebits = 0.cuint
  if styles.len >= 1:
    for s in styles[0..^1]:
      stylebits = bitor(stylebits, s.cuint)
  let code = plane.cPtr.ncplane_gradient(y.cint, x.cint, ylen.cuint,
    xlen.cuint, egc.cstring, stylebits.uint16, ul.uint64, ur.uint64, ll.uint64,
    lr.uint64)
  if code < 0.cint:
    err ApiErrorNeg(code: code.int, msg: $Grad)
  else:
    ok ApiSuccess0(code: code.int)

proc gradient2x1*(plane: Plane, y, x: int, ylen, xlen: uint, ul, ur, ll,
    lr: Channel): Result[ApiSuccess0, ApiErrorNeg] =
  let code = plane.cPtr.ncplane_gradient2x1(y.cint, x.cint, ylen.cuint,
    xlen.cuint, ul.uint32, ur.uint32, ll.uint32, lr.uint32)
  if code < 0.cint:
    err ApiErrorNeg(code: code.int, msg: $Grad2x1)
  else:
    ok ApiSuccess0(code: code.int)

func isKey*(codepoint: Codepoint): bool =
  let key = codepoint.uint32
  (key == Keys.Tab.uint32) or
  (key == Keys.Esc.uint32) or
  (key == Keys.Space.uint32) or
  (key >= Keys.Invalid.uint32 and
   key <= Keys.F60.uint32) or
  (key >= Keys.Enter.uint32 and
   key <= Keys.Separator.uint32) or
  (key >= Keys.CapsLock.uint32 and
   key <= Keys.Menu.uint32) or
  (key >= Keys.MediaPlay.uint32 and
   key <= Keys.L5Shift.uint32) or
  (key >= Keys.Motion.uint32 and
   key <= Keys.Button11.uint32) or
  (key == Keys.Signal.uint32) or
  (key == Keys.EOF.uint32)

func isKey*(input: Input): bool = input.codepoint.isKey

func isUTF8*(codepoint: Codepoint): bool =
  const highestCodepoint = 1114111.uint32
  codepoint.uint32 <= highestcodePoint

func isUTF8*(input: Input): bool = input.codepoint.isUTF8

proc putStr*(plane: Plane, s: string): Result[ApiSuccessPos, ApiError0] =
  let code = plane.cPtr.ncplane_putstr s.cstring
  if code <= 0.cint:
    err ApiError0(code: code.int, msg: $PutStr)
  else:
    ok ApiSuccessPos(code: code.int)

proc putStr*(ncd: NotcursesDirect, s: string, channel = 0.Channel):
    Result[ApiSuccess0, ApiErrorNeg] =
  let code = ncd.cPtr.ncdirect_putstr(channel.uint64, s.cstring)
  if code < 0:
    err ApiErrorNeg(code: code.int, msg: $DirectPutStr)
  else:
    ok ApiSuccess0(code: code.int)

proc putStrYX*(plane: Plane, s: string, y, x = -1'i32): Result[ApiSuccessPos, ApiError0] =
  let code = plane.cPtr.ncplane_putstr_yx(y, x, s.cstring)
  if code <= 0:
    err ApiError0(code: code.int, msg: $PutStrYX)
  else:
    ok ApiSuccessPos(code: code.int)

proc putWc*(plane: Plane, wchar: wchar_t): Result[ApiSuccess0, ApiErrorNeg] =
  # wchar_t is implementation dependent but Notcurses seems to assume 32 bits
  # (maybe for good reason); nim-notcurses' api/abi for ncplane_putwc needs
  # additional consideration; it's possible to use sizeof to check the size (in
  # bytes) of wchar_t, not sure if that's helpful in this context
  let code = plane.cPtr.ncplane_putwc wchar
  if code < 0.cint:
    err ApiErrorNeg(code: code.int, msg: $PutWc)
  else:
    ok ApiSuccess0(code: code.int)

proc render*(nc: Notcurses): Result[void, ApiErrorNeg] =
  let code = nc.cPtr.notcurses_render
  if code < 0.cint:
    err ApiErrorNeg(code: code.int, msg: $Render)
  else:
    ok()

proc setScrolling*(plane: Plane, enable: bool): Result[bool, ApiError] =
  let
    wasEnabled = plane.cPtr.ncplane_set_scrolling enable.cuint
    isEnabled = plane.getScrolling
  if isEnabled != enable:
    err ApiError(msg: $SetScroll)
  else:
    ok wasEnabled

proc setStyles*(plane: Plane, styles: varargs[Styles]) =
  var stylebits = 0.cuint
  if styles.len >= 1:
    for s in styles[0..^1]:
      stylebits = bitor(stylebits, s.cuint)
  plane.cPtr.ncplane_set_styles stylebits

# if writing to y, x is one-shot, i.e. no updates over time (maybe upon
# resize?) then can use `var int` for the parameters, and in the body have
# cuint vars, then write to the argument vars (with conversion) after abi call
proc stdDimYX*(nc: Notcurses, y, x: var uint32): Plane =
  let cPtr = nc.cPtr.notcurses_stddim_yx(addr y, addr x)
  Plane(cPtr: cPtr)

proc stdPlane*(nc: Notcurses): Plane =
  let cPtr = nc.cPtr.notcurses_stdplane
  Plane(cPtr: cPtr)

proc stop*(nc: Notcurses): Result[void, ApiErrorNeg] =
  if ncStopped.load: raise (ref ApiDefect)(msg: $AlreadyStopped)
  let code = nc.cPtr.notcurses_stop
  if code < 0.cint:
    err ApiErrorNeg(code: code.int, msg: $Stop)
  elif ncStopped.exchange(true):
    raise (ref ApiDefect)(msg: $AlreadyStopped)
  else:
    ncPtr.store(nil)
    ncApiObj = Notcurses()
    ok()

proc stop*(ncd: NotcursesDirect): Result[void, ApiErrorNeg] =
  if ncStopped.load: raise (ref ApiDefect)(msg: $AlreadyStopped)
  let code = ncd.cPtr.ncdirect_stop
  if code < 0:
    err ApiErrorNeg(code: code.int, msg: $DirectStop)
  elif ncStopped.exchange(true):
    raise (ref ApiDefect)(msg: $AlreadyStopped)
  else:
    ncPtr.store(nil)
    ncdApiObj = NotcursesDirect()
    ok()

proc stopNotcurses() {.noconv.} = Notcurses.get.stop.expect

proc stopNotcursesDirect() {.noconv.} = NotcursesDirect.get.stop.expect

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  import std/exitprocs
  template addExitProc*(T: type Notcurses) =
    if not ncExitProcAdded.exchange(true): addExitProc stopNotcurses
  template addExitProc*(T: type NotcursesDirect) =
    if not ncExitProcAdded.exchange(true): addExitProc stopNotcursesDirect
else:
  template addExitProc*(T: type Notcurses) =
    if not ncExitProcAdded.exchange(true): addQuitProc stopNotcurses
  template addExitProc*(T: type NotcursesDirect) =
    if not ncExitProcAdded.exchange(true): addQuitProc stopNotcursesDirect

proc init*(T: type Notcurses, options = Options.init, file = stdout,
    addExitProc = true): T =
  if not ncPtr.load.isNil:
    raise (ref ApiDefect)(msg: $AlreadyInitialized)
  else:
    # it became necessary re: recent commits in Nim's version-1-6 and
    # version-2-0 branches to here use `ptr abi.notcurses` or
    # `ptr core.notcurses` instead of `ptr notcurses` (latter is used elsewhere
    # in this module); seems like a compiler bug; regardless, happily, the
    # change is compatible with older versions of Nim
    when compiles(abi.notcurses):
      var cPtr: ptr abi.notcurses
    else:
      var cPtr: ptr core.notcurses
    when (NimMajor, NimMinor, NimPatch) < (1, 6, 0):
      try:
        cPtr = ncInit(unsafeAddr options.cObj, file)
      except Exception:
        raise (ref ApiDefect)(msg: $FailedToInitialize)
    else:
      cPtr = ncInit(unsafeAddr options.cObj, file)
    if cPtr.isNil: raise (ref ApiDefect)(msg: $FailedToInitialize)
    ncApiObj = T(cPtr: cPtr)
    if not ncPtr.exchange(cast[pointer](ncApiObj.cPtr)).isNil:
      raise (ref ApiDefect)(msg: $AlreadyInitialized)
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
    ncStopped.store(false)
    ncApiObj

proc init*(T: type NotcursesDirect, options = DirectOptions.init, file = stdout,
    addExitProc = true): T =
  if not ncPtr.load.isNil:
    raise (ref ApiDefect)(msg: $AlreadyInitialized)
  else:
    # it became necessary re: recent commits in Nim's version-1-6 and
    # version-2-0 branches to here use `ptr abi.ncdirect` or
    # `ptr core.ncdirect` instead of `ptr ncdirect` (latter is used elsewhere
    # in this module); seems like a compiler bug; regardless, happily, the
    # change is compatible with older versions of Nim
    when compiles(abi.ncdirect):
      var cPtr: ptr abi.ncdirect
    else:
      var cPtr: ptr core.ncdirect
    var term: cstring
    if options.term != "": term = options.term.cstring
    when (NimMajor, NimMinor, NimPatch) < (1, 6, 0):
      try:
        cPtr = ncdInit(term, file, options.flags)
      except Exception:
        raise (ref ApiDefect)(msg: $FailedToInitialize)
    else:
      cPtr = ncdInit(term, file, options.flags)
    if cPtr.isNil: raise (ref ApiDefect)(msg: $FailedToInitialize)
    ncdApiObj = T(cPtr: cPtr)
    if not ncPtr.exchange(cast[pointer](ncdApiObj.cPtr)).isNil:
      raise (ref ApiDefect)(msg: $AlreadyInitialized)
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
    ncStopped.store(false)
    ncdApiObj

func toKey*(input: Input): Option[Keys] =
  if input.isKey: some(cast[Keys](input.codepoint))
  else: none[Keys]()

func toUTF8*(input: Input): Option[string] =
  if input.isUTF8:
    const nullC = '\x00'.cchar
    var bytes: seq[byte]
    bytes.add input.cObj.utf8[0].byte
    for c in input.cObj.utf8[1..3]:
      if c != nullC: bytes.add c.byte
      else: break
    some(string.fromBytes bytes)
  else:
    none[string]()

# Aliases
type
  Nc* = Notcurses
  NcChannel* = Channel
  NcCodepoint* = Codepoint
  NcInput* = Input
  NcKeys* = Keys
  NcLogLevels* = LogLevels
  NcMargins* = Margins
  NcOptions* = Options
  NcPlane* = Plane
  NcStyles* = Styles
  Ncd* = NotcursesDirect
  NcdOptions* = DirectOptions
