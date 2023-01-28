when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[atomics, bitops, options]

import pkg/stew/[byteutils, results]

export options, byteutils, results, wchar_t

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

  Input* = object
    # make this private again
    abiObj*: ncinput

  Margins* = tuple[top, right, bottom, left: uint32]

  Notcurses* = object
    # make this private again
    abiPtr*: ptr notcurses

  Options* = object
    abiObj: notcurses_options

  Plane* = object
    # make this private again
    abiPtr*: ptr ncplane

const
  NimNotcursesMajor* = nim_notcurses_version.major.int
  NimNotcursesMinor* = nim_notcurses_version.minor.int
  NimNotcursesPatch* = nim_notcurses_version.patch.int

let
  LibNotcursesMajor* = lib_notcurses_major.int
  LibNotcursesMinor* = lib_notcurses_minor.int
  LibNotcursesPatch* = lib_notcurses_patch.int
  LibNotcursesTweak* = lib_notcurses_tweak.int

var
  ncAbiPtr: Atomic[ptr notcurses]
  ncApiObject {.threadvar.}: Notcurses
  ncExitProcAdded: Atomic[bool]
  ncStopped: Atomic[bool]

func `$`*(codepoint: Codepoint): string = $codepoint.uint32

func `$`*(input: Input): string = $input.abiObj

func `$`*(options: Options): string = $options.abiObj

func codepoint*(input: Input): Codepoint = input.abiObj.id.Codepoint

# if writing to y, x is one-shot, i.e. no updates over time (maybe upon
# resize?) then can use `var int` for the parameters, and in the body have
# cuint vars, then write to the argument vars (with conversion) after abi call
proc dimYX*(plane: Plane, y, x: var cuint) =
  plane.abiPtr.ncplane_dim_yx(addr y, addr x)

proc dimYX*(plane: Plane): Dimensions =
  var y, x: cuint
  plane.dimYX(y, x)
  (y: y.int, x: x.int)

func event*(input: Input): InputEvents = cast[InputEvents](input.abiObj.evtype)

proc expect*[T: ApiSuccess | bool, E: ApiError](res: Result[T, E]): T
    {.discardable.} =
  expect(res, $FailureNotExpected)

proc expect*[E: ApiError](res: Result[void, E]) =
  expect(res, $FailureNotExpected)

proc get*(T: type Notcurses): T =
  if ncApiObject.abiPtr.isNil:
    let abiPtr = ncAbiPtr.load
    if abiPtr.isNil:
      raise (ref ApiDefect)(msg: $NotInitialized)
    else:
      ncApiObject = T(abiPtr: abiPtr)
  ncApiObject

# when implementing api for notcurses_get, etc. (i.e. the abi calls that return
# 0.uint32 on timeout), use Option none for timeout and Option some
# NotcursesCodepoint otherwise

proc getBlocking*(notcurses: Notcurses, input: var Input) =
  discard notcurses.abiPtr.notcurses_get_blocking(unsafeAddr input.abiObj)

func init*(T: type Channel, r, g, b: int): T =
  NCCHANNEL_INITIALIZER(r.cint, g.cint, b.cint).T

func init*(T: type Channel, fr, fg, fb, br, bg, bb: int): T =
  NCCHANNELS_INITIALIZER(fr.cint, fg.cint, fb.cint, br.cint, bg.cint, bb.cint).T

func init*(T: type Margins, top, right, bottom, left: int = 0): T =
  (top: top.uint32, right: right.uint32, bottom: bottom.uint32,
   left: left.uint32)

func init*(T: type Options, initOptions: varargs[InitOptions], term = "",
    logLevel: LogLevels = LogLevels.Panic, margins: Margins = Margins.init): T =
  var flags = baseInitOption.culonglong
  if initOptions.len >= 1:
    for o in initOptions[0..^1]:
      flags = bitor(flags, o.culonglong)
  if term == "":
    T(abiObj: notcurses_options(loglevel: cast[ncloglevel_e](logLevel),
      margin_t: margins.top.cuint, margin_r: margins.right.cuint,
      margin_b: margins.bottom.cuint, margin_l: margins.left.cuint,
      flags: flags))
  else:
    T(abiObj: notcurses_options(termtype: term.cstring,
      loglevel: cast[ncloglevel_e](logLevel), margin_t: margins.top.cuint,
      margin_r: margins.right.cuint, margin_b: margins.bottom.cuint,
      margin_l: margins.left.cuint, flags: flags))

func init*(T: type Input): T = T(abiObj: ncinput())

proc getBlocking*(notcurses: Notcurses): Input =
  var input = Input.init
  notcurses.getBlocking input
  input

func getScrolling*(plane: Plane): bool = plane.abiPtr.ncplane_scrolling_p

proc gradient*(plane: Plane, y, x: int, ylen, xlen: uint, ul, ur, ll,
    lr: Channel, egc: string = "", styles: varargs[Styles]):
    Result[ApiSuccess0, ApiErrorNeg] =
  var stylebits = 0.cuint
  if styles.len >= 1:
    for s in styles[0..^1]:
      stylebits = bitor(stylebits, s.cuint)
  let code = plane.abiPtr.ncplane_gradient(y.cint, x.cint, ylen.cuint,
    xlen.cuint, egc.cstring, stylebits.uint16, ul.uint64, ur.uint64, ll.uint64,
    lr.uint64)
  if code < 0.cint:
    err ApiErrorNeg(code: code.int, msg: $Grad)
  else:
    ok ApiSuccess0(code: code.int)

proc gradient2x1*(plane: Plane, y, x: int, ylen, xlen: uint, ul, ur, ll,
    lr: Channel): Result[ApiSuccess0, ApiErrorNeg] =
  let code = plane.abiPtr.ncplane_gradient2x1(y.cint, x.cint, ylen.cuint,
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
  let code = plane.abiPtr.ncplane_putstr s.cstring
  if code <= 0.cint:
    err ApiError0(code: code.int, msg: $PutStr)
  else:
    ok ApiSuccessPos(code: code.int)

proc putStrYX*(plane: Plane, s: string, y, x: int32 = -1): Result[ApiSuccessPos, ApiError0] =
  let code = plane.abiPtr.ncplane_putstr_yx(y, x, s.cstring)
  if code <= 0:
    err ApiError0(code: code.int, msg: $PutStrYX)
  else:
    ok ApiSuccessPos(code: code.int)

proc putWc*(plane: Plane, wchar: wchar_t): Result[ApiSuccess0, ApiErrorNeg] =
  # wchar_t is implementation dependent but Notcurses seems to assume 32 bits
  # (maybe for good reason); nim-notcurses' api/abi for ncplane_putwc needs
  # additional consideration; it's possible to use sizeof to check the size (in
  # bytes) of wchar_t, not sure if that's helpful in this context
  let code = plane.abiPtr.ncplane_putwc wchar
  if code < 0.cint:
    err ApiErrorNeg(code: code.int, msg: $PutWc)
  else:
    ok ApiSuccess0(code: code.int)

proc render*(notcurses: Notcurses): Result[void, ApiErrorNeg] =
  let code = notcurses.abiPtr.notcurses_render
  if code < 0.cint:
    err ApiErrorNeg(code: code.int, msg: $Render)
  else:
    ok()

proc setScrolling*(plane: Plane, enable: bool): Result[bool, ApiError] =
  let
    wasEnabled = plane.abiPtr.ncplane_set_scrolling enable.cuint
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
  plane.abiPtr.ncplane_set_styles stylebits

# if writing to y, x is one-shot, i.e. no updates over time (maybe upon
# resize?) then can use `var int` for the parameters, and in the body have
# cuint vars, then write to the argument vars (with conversion) after abi call
proc stdDimYX*(notcurses: Notcurses, y, x: var cuint): Plane =
  let abiPtr = notcurses.abiPtr.notcurses_stddim_yx(addr y, addr x)
  Plane(abiPtr: abiPtr)

proc stdPlane*(notcurses: Notcurses): Plane =
  let abiPtr = notcurses.abiPtr.notcurses_stdplane
  Plane(abiPtr: abiPtr)

proc stop*(notcurses: Notcurses): Result[void, ApiErrorNeg] =
  if ncStopped.load: raise (ref ApiDefect)(msg: $AlreadyStopped)
  let code = notcurses.abiPtr.notcurses_stop
  if code < 0.cint:
    err ApiErrorNeg(code: code.int, msg: $Stop)
  elif ncStopped.exchange(true):
    raise (ref ApiDefect)(msg: $AlreadyStopped)
  else:
    ok()

proc stopNotcurses() {.noconv.} = Notcurses.get.stop.expect

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  import std/exitprocs
  template addExitProc*(T: type Notcurses) =
    if not ncExitProcAdded.exchange(true): addExitProc stopNotcurses
else:
  template addExitProc*(T: type Notcurses) =
    if not ncExitProcAdded.exchange(true): addQuitProc stopNotcurses

proc init*(T: type Notcurses, options: Options = Options.init,
    file: File = stdout, addExitProc = true): T =
  if not ncApiObject.abiPtr.isNil or not ncAbiPtr.load.isNil:
    raise (ref ApiDefect)(msg: $AlreadyInitialized)
  else:
    let abiPtr = abiInit(unsafeAddr options.abiObj, file)
    if abiPtr.isNil: raise (ref ApiDefect)(msg: $FailedToInitialize)
    ncApiObject = T(abiPtr: abiPtr)
    if not ncAbiPtr.exchange(ncApiObject.abiPtr).isNil:
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
    ncApiObject

func toKey*(input: Input): Option[Keys] =
  if input.isKey: some(cast[Keys](input.codepoint))
  else: none[Keys]()

func toUTF8*(input: Input): Option[string] =
  if input.isUTF8:
    const nullC = '\x00'.cchar
    var bytes: seq[byte]
    bytes.add input.abiObj.utf8[0].byte
    for c in input.abiObj.utf8[1..3]:
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
