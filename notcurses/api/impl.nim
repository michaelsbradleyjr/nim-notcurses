when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[atomics, bitops, options, strformat, strutils]

import pkg/stew/[byteutils, results]

export options, results, wchar_t

# should consider moving some of the types and constants here into
# api/constants, as done with abi/constants re: abi/impl, but there will be
# additional considerations when splitting out support for Direct mode into
# api/direct/constants,impl

type
  ApiDefect* = object of Defect

  ApiError* = object of CatchableError

  ApiError0* = object of ApiError
    code*: range[low(int32)..0'i32]

  ApiErrorNeg* = object of ApiError
    code*: range[low(int32)..(-1'i32)]

  # take care that `code != 0` to avoid confusion re: name of this type
  ApiErrorNot0* = object of ApiError
    code*: int32

  ApiSuccess* = object of RootObj

  ApiSuccess0* = object of ApiSuccess
    code*: range[0'i32..high(int32)]

  ApiSuccessOnly0* = object of ApiSuccess
    code*: range[0'i32..0'i32]

  ApiSuccessPos* = object of ApiSuccess
    code*: range[1'i32..high(int32)]

  Channel* = distinct uint32

  ChannelPair* = distinct uint64

  Codepoint* = distinct uint32

  DirectOptions* = object
    flags: uint64
    term: string

  # need to understand Gcluster better, especially re: cell initializers,
  # i.e. grapheme clusters can be multiple codepoints... check again re:
  # whether in cell init macros in C and the type they construct we're
  # dealing with uint32s or pointers, i.e. UncheckedArrays from Nim's
  # perspective
  # Gcluster* = distinct uint32

  Input* = object
    # make this private again, it's only public for now to support mixed
    # api/abi usage in examples under development
    cObj*: ncinput

  Margins* = tuple[top, right, bottom, left: uint32]

  Notcurses* = object
    # make this private again, it's only public for now to support mixed
    # api/abi usage in examples under development
    cPtr*: ptr notcurses

  NotcursesDirect* = object
    cPtr: ptr ncdirect

  Options* = object
    cObj: notcurses_options

  Plane* = object
    # make this private again, it's only public for now to support mixed
    # api/abi usage in examples under development
    cPtr*: ptr ncplane

  PlaneDimensions* = tuple[y, x: uint32]

  TermDimensions* = tuple[rows, cols: uint32]

  Ucs32 = distinct uint32

const
  HighUcs32* = 0x0010ffff'u32.Ucs32

  NimNotcursesMajor* = nim_notcurses_version.major.int
  NimNotcursesMinor* = nim_notcurses_version.minor.int
  NimNotcursesPatch* = nim_notcurses_version.patch.int

  # https://codepoints.net/U+FFFD
  ReplacementChar* = string.fromBytes hexToByteArray("0xefbfbd", 3)

var
  lib_notcurses_major: int32
  lib_notcurses_minor: int32
  lib_notcurses_patch: int32
  lib_notcurses_tweak: int32

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

func fmtPoint(point: uint32): string =
  let hex = point.uint64.toHex.strip(
    chars = {'0'}, trailing = false).toUpperAscii
  try:
    fmt"{hex:0>4}"
  except ValueError as e:
    raise (ref Defect)(msg: e.msg)

func `$`*(codepoint: Codepoint): string =
  let
    c = codepoint.uint32
    hex = c.fmtPoint
  var pri, sec: string
  if c <= HighUcs32.uint32:
    pri = "U+"
    if c in AllKeys: sec = "NCKEY+"
  elif c in AllKeys:
    pri = "NCKEY+"
  if pri == "" and sec == "":
    raise (ref ApiDefect)(msg: $InvalidCodepoint & " " & hex)
  pri & hex & (if sec != "": " | " & sec & hex else: "")

func `$`*(input: Input): string = $input.cObj

func `$`*(options: Options): string = $options.cObj

func `$`*(codepoint: Ucs32): string =
  let
    c = codepoint.uint32
    hex = c.fmtPoint
  if c > HighUcs32.uint32:
    raise (ref ApiDefect)(msg: $InvalidUcs32 & " " & hex)
  "U+" & hex

func codepoint*(input: Input): Codepoint = input.cObj.id.Codepoint

func cursorY*(plane: Plane): uint32 = plane.cPtr.ncplane_cursor_y

proc dimYx*(plane: Plane, y, x: var uint32) =
  plane.cPtr.ncplane_dim_yx(addr y, addr x)

proc dimYx*(plane: Plane): PlaneDimensions =
  var y, x: uint32
  plane.dimYx(y, x)
  (y, x)

func event*(input: Input): InputEvents = cast[InputEvents](input.cObj.evtype)

proc expect*[T: ApiSuccess | bool, E: ApiError](res: Result[T, E],
    m = $FailureNotExpected): T {.discardable.} =
  results.expect(res, m)

proc expect*[E: ApiError](res: Result[void, E], m = $FailureNotExpected) =
  results.expect(res, m)

# use template/macro for `proc get` when breaking up api layer into
# included-modules to reduce source code duplication

proc get*(T: type Notcurses): T =
  let cPtr = ncPtr.load
  if cPtr.isNil:
    raise (ref ApiDefect)(msg: $NotInitialized)
  elif ncApiObj.cPtr.isNil or ncApiObj.cPtr != cPtr:
    ncApiObj = T(cPtr: cast[ptr abi.notcurses](cPtr))
  ncApiObj

proc get*(T: type NotcursesDirect): T =
  let cPtr = ncPtr.load
  if cPtr.isNil:
    raise (ref ApiDefect)(msg: $NotInitialized)
  elif ncdApiObj.cPtr.isNil or ncdApiObj.cPtr != cPtr:
    ncdApiObj = T(cPtr: cast[ptr abi.ncdirect](cPtr))
  ncdApiObj

# for `notcurses_get`, etc. (i.e. abi calls that return 0'u32 on timeout), use
# Option none for timeout and Option some Codepoint otherwise

proc getBlocking*(nc: Notcurses, input: var Input) =
  discard nc.cPtr.notcurses_get_blocking(addr input.cObj)

func getScrolling*(plane: Plane): bool = plane.cPtr.ncplane_scrolling_p

proc gradient*(plane: Plane, y, x: int32, ylen, xlen: uint32, ul, ur, ll,
    lr: ChannelPair, egc = "", styles: varargs[Styles]):
    Result[ApiSuccess0, ApiErrorNeg] =
  var stylebits = 0'u32
  for s in styles[0..^1]:
    stylebits = bitor(stylebits, s.uint32)
  let code = plane.cPtr.ncplane_gradient(y, x, ylen, xlen, egc.cstring,
    stylebits.uint16, ul.uint64, ur.uint64, ll.uint64, lr.uint64)
  if code < 0:
    err ApiErrorNeg(code: code, msg: $Grad)
  else:
    ok ApiSuccess0(code: code)

proc gradient2x1*(plane: Plane, y, x: int32, ylen, xlen: uint32, ul, ur, ll,
    lr: Channel): Result[ApiSuccess0, ApiErrorNeg] =
  let code = plane.cPtr.ncplane_gradient2x1(y, x, ylen, xlen, ul.uint32,
    ur.uint32, ll.uint32, lr.uint32)
  if code < 0:
    err ApiErrorNeg(code: code, msg: $Grad2x1)
  else:
    ok ApiSuccess0(code: code)

func init*(T: type Channel, r, g, b: uint32): T =
  NCCHANNEL_INITIALIZER(r, g, b).T

func init*(T: type ChannelPair, fr, fg, fb, br, bg, bb: uint32): T =
  NCCHANNELS_INITIALIZER(fr, fg, fb, br, bg, bb).T

func init*(T: type Input): T = T(cObj: ncinput())

proc getBlocking*(nc: Notcurses): Input =
  var input = Input.init
  nc.getBlocking input
  input

func init*(T: type Margins, top, right, bottom, left = 0'u32): T =
  (top, right, bottom, left)

# when breaking up api layer into included-modules, refactor baseInitOption to
# be a param with default value, e.g. CliMode; also constants baseInitOption,
# ncInit, ncdInit in the various init,core/init modules can probably be
# refactored as params of a template/macro used to generate the init funcs

func init*(T: type Options, initOptions: openArray[InitOptions] = [], term = "",
    logLevel = LogLevels.Panic, margins = Margins.init): T =
  var flags = baseInitOption.uint64
  for o in initOptions[0..^1]:
    flags = bitor(flags, o.uint64)
  var termtype: cstring
  if term != "": termtype = term.cstring
  T(cObj: notcurses_options(termtype: termtype,
    loglevel: cast[ncloglevel_e](logLevel), margin_t: margins.top,
    margin_r: margins.right, margin_b: margins.bottom, margin_l: margins.left,
    flags: flags))

func init*(T: type DirectOptions,
    initOptions: openArray[DirectInitOptions] = [], term = ""): T =
  var flags = 0'u64
  for o in initOptions[0..^1]:
    flags = bitor(flags, o.uint64)
  T(flags: flags, term: term)

func key*(input: Input): Option[Keys] =
  let codepoint = input.codepoint
  if codepoint.uint32 in AllKeys: some cast[Keys](codepoint)
  else: none[Keys]()

proc putStr*(plane: Plane, s: string): Result[ApiSuccessPos, ApiError0] =
  let code = plane.cPtr.ncplane_putstr s.cstring
  if code <= 0:
    err ApiError0(code: code, msg: $PutStr)
  else:
    ok ApiSuccessPos(code: code)

proc putStr*(ncd: NotcursesDirect, s: string, channel = 0.Channel):
    Result[ApiSuccess0, ApiErrorNeg] =
  let code = ncd.cPtr.ncdirect_putstr(channel.uint64, s.cstring)
  if code < 0:
    err ApiErrorNeg(code: code, msg: $DirectPutStr)
  else:
    ok ApiSuccess0(code: code)

proc putStrAligned*(plane: Plane, s: string, alignment: Align, y = -1'i32):
    Result[ApiSuccessPos, ApiError0] =
  let code = plane.cPtr.ncplane_putstr_aligned(y, cast[ncalign_e](alignment),
    s.cstring)
  if code <= 0:
    err ApiError0(code: code, msg: $PutStrYx)
  else:
    ok ApiSuccessPos(code: code)

proc putStrYx*(plane: Plane, s: string, y, x = -1'i32):
    Result[ApiSuccessPos, ApiError0] =
  let code = plane.cPtr.ncplane_putstr_yx(y, x, s.cstring)
  if code <= 0:
    err ApiError0(code: code, msg: $PutStrYx)
  else:
    ok ApiSuccessPos(code: code)

proc putWc*(plane: Plane, wc: wchar_t): Result[ApiSuccess0, ApiErrorNeg] =
  let code = plane.cPtr.ncplane_putwc wc
  if code < 0:
    err ApiErrorNeg(code: code, msg: $PutWc)
  else:
    ok ApiSuccess0(code: code)

proc render*(nc: Notcurses): Result[void, ApiErrorNeg] =
  let code = nc.cPtr.notcurses_render
  if code < 0:
    err ApiErrorNeg(code: code, msg: $Render)
  else:
    ok()

proc setScrolling*(plane: Plane, enable: bool): Result[bool, ApiError] =
  let
    wasEnabled = plane.cPtr.ncplane_set_scrolling enable.uint32
    isEnabled = plane.getScrolling
  if isEnabled != enable:
    err ApiError(msg: $SetScroll)
  else:
    ok wasEnabled

proc setStyles*(plane: Plane, styles: varargs[Styles]) =
  var stylebits = 0'u32
  for s in styles[0..^1]:
    stylebits = bitor(stylebits, s.uint32)
  plane.cPtr.ncplane_set_styles stylebits

proc setStyles*(ncd: NotcursesDirect, styles: varargs[Styles]):
    Result[ApiSuccessOnly0, ApiErrorNot0] =
  var stylebits = 0'u32
  for s in styles[0..^1]:
    stylebits = bitor(stylebits, s.uint32)
  let code = ncd.cPtr.ncdirect_set_styles stylebits
  if code != 0:
    err ApiErrorNot0(code: code, msg: $DirectSetStyles)
  else:
    ok ApiSuccessOnly0(code: code)

proc stdDimYx*(nc: Notcurses, y, x: var uint32): Plane =
  let cPtr = nc.cPtr.notcurses_stddim_yx(addr y, addr x)
  Plane(cPtr: cPtr)

proc stdPlane*(nc: Notcurses): Plane =
  let cPtr = nc.cPtr.notcurses_stdplane
  Plane(cPtr: cPtr)

# use template/macro for `proc stop` when breaking up api layer into
# included-modules to reduce source code duplication

proc stop*(nc: Notcurses) =
  if ncStopped.load: raise (ref ApiDefect)(msg: $AlreadyStopped)
  let code = nc.cPtr.notcurses_stop
  if code < 0:
    raise (ref ApiDefect)(msg: $FailedToStop)
  elif ncStopped.exchange(true):
    raise (ref ApiDefect)(msg: $AlreadyStopped)
  else:
    ncPtr.store(nil)
    ncApiObj = Notcurses()

proc stop*(ncd: NotcursesDirect) =
  if ncStopped.load: raise (ref ApiDefect)(msg: $AlreadyStopped)
  let code = ncd.cPtr.ncdirect_stop
  if code < 0:
    raise (ref ApiDefect)(msg: $FailedToStop)
  elif ncStopped.exchange(true):
    raise (ref ApiDefect)(msg: $AlreadyStopped)
  else:
    ncPtr.store(nil)
    ncdApiObj = NotcursesDirect()

proc stopNotcurses() {.noconv.} = Notcurses.get.stop

proc stopNotcursesDirect() {.noconv.} = NotcursesDirect.get.stop

# use template/macro for `template addExitProc` when breaking up api layer into
# included-modules to reduce source code duplication

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

# use template/macro for `proc init` when breaking up api layer into
# included-modules to reduce source code duplication

proc init*(T: type Notcurses, options = Options.init, file = stdout,
    addExitProc = true): T =
  if not ncPtr.load.isNil:
    raise (ref ApiDefect)(msg: $AlreadyInitialized)
  else:
    var cOpts = options.cObj
    var cPtr: ptr abi.notcurses
    when (NimMajor, NimMinor, NimPatch) < (1, 6, 0):
      try:
        cPtr = ncInit(addr cOpts, file)
      except Exception:
        raise (ref ApiDefect)(msg: $FailedToInitialize)
    else:
      cPtr = ncInit(addr cOpts, file)
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
    var cPtr: ptr abi.ncdirect
    var termtype: cstring
    if options.term != "": termtype = options.term.cstring
    when (NimMajor, NimMinor, NimPatch) < (1, 6, 0):
      try:
        cPtr = ncdInit(termtype, file, options.flags)
      except Exception:
        raise (ref ApiDefect)(msg: $FailedToInitialize)
    else:
      cPtr = ncdInit(termtype, file, options.flags)
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

func supportedStyles*(ncd: NotcursesDirect): uint16 =
  ncd.cPtr.ncdirect_supported_styles

func toBytes(buf: array[5, char]): seq[byte] =
  const nullC = '\x00'.char
  var bytes: seq[byte]
  bytes.add buf[0].byte
  for c in buf[1..3]:
    if c != nullC: bytes.add c.byte
    else: break
  bytes

func bytes(input: Input, skipHigh = false): Option[seq[byte]] =
  # assumption: `input.cObj.utf8` contains 1-4 bytes of a valid UTF-8 encoding
  if skipHigh or (input.codepoint.uint32 <= HighUcs32.uint32):
    some input.cObj.utf8.toBytes
  else:
    none[seq[byte]]()

func bytes*(input: Input): Option[seq[byte]] = input.bytes(false)

func toCodepoint*(u: Ucs32 | uint8 | uint16 | uint32): Option[Codepoint] =
  let u32 = u.uint32
  if (u32 <= HighUcs32.uint32) or (u32 in AllKeys): some u32.Codepoint
  else: none()

func toUcs32*(u: Codepoint | uint8 | uint16 | uint32): Option[Ucs32] =
  let u32 = u.uint32
  if u32 <= HighUcs32.uint32: some u32.Ucs32
  else: none()

func toUtf8*(codepoint: Codepoint | Ucs32): Option[string] =
  var
    buf: array[5, char]
    c = codepoint.uint32
  let code = notcurses_ucs32_to_utf8(addr c, 1,
    cast[ptr UncheckedArray[char]](addr buf), 5)
  if code >= 0: some string.fromBytes(buf.toBytes)
  else: none()

func utf8*(input: Input): Option[string] =
  # assumption: if input's codepoint is valid UCS32 then it has a valid encoding
  let c = input.codepoint.uint32
  if c <= HighUcs32.uint32:
    some string.fromBytes(input.bytes(skipHigh = true).get)
  else:
    none[string]()

# Aliases
type
  Nc* = Notcurses
  NcChannel* = Channel
  NcChannels* = ChannelPair
  NcOptions* = Options
  Ncd* = NotcursesDirect
  NcdOptions* = DirectOptions
