when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[atomics, bitops, options]

import pkg/stew/[byteutils, results]

export bitops, byteutils, options, results

type
  ApiDefect* = object of Defect

  ApiError* = object of CatchableError

  ApiError0* = object of ApiError
    code*: range[low(int32)..0'i32]

  ApiErrorNeg* = object of ApiError
    code*: range[low(int32)..(-1'i32)]

  ApiErrorNot0* = object of ApiError
    # user must discriminate zero
    code*: range[low(int32)..high(int32)]

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

  PlaneDimensions* = tuple[y, x: uint32]

  TermDimensions* = tuple[rows, cols: uint32]

const
  NimNotcursesMajor* = nim_notcurses_version.major.int
  NimNotcursesMinor* = nim_notcurses_version.minor.int
  NimNotcursesPatch* = nim_notcurses_version.patch.int

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

func `$`*(codepoint: Codepoint): string = $codepoint.uint32

func `$`*(input: Input): string = $input.cObj

func `$`*(options: Options): string = $options.cObj

func codepoint*(input: Input): Codepoint = input.cObj.id.Codepoint

proc dimYX*(plane: Plane, y, x: var uint32) =
  plane.cPtr.ncplane_dim_yx(addr y, addr x)

proc dimYX*(plane: Plane): PlaneDimensions =
  var y, x: uint32
  plane.dimYX(y, x)
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
    when compiles(abi.ncdirect):
      ncdApiObj = T(cPtr: cast[ptr abi.ncdirect](cPtr))
    else:
      ncdApiObj = T(cPtr: cast[ptr core.ncdirect](cPtr))
  ncdApiObj

# for `notcurses_get`, etc. (i.e. abi calls that return 0'u32 on timeout), use
# Option none for timeout and Option some Codepoint otherwise

proc getBlocking*(nc: Notcurses, input: var Input) =
  discard nc.cPtr.notcurses_get_blocking(addr input.cObj)

func init*(T: type Channel, r, g, b: uint32): T =
  NCCHANNEL_INITIALIZER(r, g, b).T

func init*(T: type ChannelPair, fr, fg, fb, br, bg, bb: uint32): T =
  NCCHANNELS_INITIALIZER(fr, fg, fb, br, bg, bb).T

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

func init*(T: type Input): T = T(cObj: ncinput())

proc getBlocking*(nc: Notcurses): Input =
  var input = Input.init
  nc.getBlocking input
  input

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

func isKey*(codepoint: Codepoint): bool =
  let key = codepoint.uint32
  (key >= Keys.Invalid.uint32 and
    ((key <= Keys.F60.uint32) or
     (key >= Keys.Enter.uint32 and
      key <= Keys.Separator.uint32) or
     (key >= Keys.CapsLock.uint32 and
      key <= Keys.Menu.uint32) or
     (key >= Keys.MediaPlay.uint32 and
      key <= Keys.L5Shift.uint32) or
     (key >= Keys.Motion.uint32 and
      key <= Keys.Button11.uint32) or
     (key == Keys.Signal.uint32) or
     (key == Keys.EOF.uint32))) or
  (key == Keys.Tab.uint32) or
  (key == Keys.Esc.uint32) or
  (key == Keys.Space.uint32)

func isKey*(input: Input): bool = input.codepoint.isKey

func isUTF8*(input: Input): bool =
  # quick test that Input's underlying codepoint is not in Keys
  const highest = 0x0010ffff'u32
  input.cObj.id <= highest

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

proc putStrYX*(plane: Plane, s: string, y, x = -1'i32):
    Result[ApiSuccessPos, ApiError0] =
  let code = plane.cPtr.ncplane_putstr_yx(y, x, s.cstring)
  if code <= 0:
    err ApiError0(code: code, msg: $PutStrYX)
  else:
    ok ApiSuccessPos(code: code)

proc putWc*(plane: Plane, wchar: wchar_t): Result[ApiSuccess0, ApiErrorNeg] =
  let code = plane.cPtr.ncplane_putwc wchar
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

proc stdDimYX*(nc: Notcurses, y, x: var uint32): Plane =
  let cPtr = nc.cPtr.notcurses_stddim_yx(addr y, addr x)
  Plane(cPtr: cPtr)

proc stdPlane*(nc: Notcurses): Plane =
  let cPtr = nc.cPtr.notcurses_stdplane
  Plane(cPtr: cPtr)

# use template/macro for `proc stop` when breaking up api layer into
# included-modules to reduce source code duplication

proc stop*(nc: Notcurses): Result[void, ApiErrorNeg] =
  if ncStopped.load: raise (ref ApiDefect)(msg: $AlreadyStopped)
  let code = nc.cPtr.notcurses_stop
  if code < 0:
    err ApiErrorNeg(code: code, msg: $Stop)
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
    err ApiErrorNeg(code: code, msg: $DirectStop)
  elif ncStopped.exchange(true):
    raise (ref ApiDefect)(msg: $AlreadyStopped)
  else:
    ncPtr.store(nil)
    ncdApiObj = NotcursesDirect()
    ok()

proc stopNotcurses() {.noconv.} = Notcurses.get.stop.expect

proc stopNotcursesDirect() {.noconv.} = NotcursesDirect.get.stop.expect

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
    # it became necessary re: recent commits in Nim's version-1-6 and
    # version-2-0 branches to here use `ptr abi.ncdirect` or
    # `ptr core.ncdirect` instead of `ptr ncdirect` (latter is used elsewhere
    # in this module); seems like a compiler bug; regardless, happily, the
    # change is compatible with older versions of Nim
    when compiles(abi.ncdirect):
      var cPtr: ptr abi.ncdirect
    else:
      var cPtr: ptr core.ncdirect
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

func toKey*(input: Input): Option[Keys] =
  if input.isKey: some(cast[Keys](input.codepoint))
  else: none[Keys]()

template toUTF8(buf: array[5, char]): string =
  const nullC = '\x00'.char
  var bytes: seq[byte]
  bytes.add buf[0].byte
  for c in buf[1..3]:
    if c != nullC: bytes.add c.byte
    else: break
  string.fromBytes bytes

func toUTF8*(codepoint: Codepoint): Option[string] =
  var
    buf: array[5, char]
    c = codepoint.uint32
  let code = notcurses_ucs32_to_utf8(addr c, 1,
    cast[ptr UncheckedArray[char]](addr buf), 5)
  if code < 0:
    none[string]()
  else:
    some(buf.toUTF8)

func isUTF8*(codepoint: Codepoint): bool =
  # test is non-trivial to implement correctly so rely on libunistring
  # converter to effectively test if codepoint can be encoded as UTF-8
  codepoint.toUTF8.isSome

func toUTF8*(input: Input): Option[string] =
  # assumptions: if input's underlying codepoint is not in Keys then (1) it can
  # be validly encoded in UTF-8 and (2) Notcurses has populated `cObj.utf8`
  # with 1-4 bytes for that encoding
  if input.isUTF8:
    some(input.cObj.utf8.toUTF8)
  else:
    none[string]()

func wchar_t*(wc: SomeInteger): wchar_t =
  when compiles(abi.wchar_t):
    cast[abi.wchar_t](wc)
  else:
    cast[core.wchar_t](wc)

# Aliases
type
  Nc* = Notcurses
  NcChannel* = Channel
  NcChannels* = ChannelPair
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
