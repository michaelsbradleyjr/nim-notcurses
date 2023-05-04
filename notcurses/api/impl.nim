when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[atomics, bitops, macros, options, sets, strformat, strutils]
import pkg/stew/[byteutils, results]
import ../abi/impl
import ./common
import ./constants

export Time, Timespec, options
export common except ApiDefect, isNcInited, isNcdInited, setNcInited,
  setNcIniting, setNcStopped, setNcStopping, setNcdInited, setNcdIniting,
  setNcdStopped, setNcdStopping
export constants except AllKeys, DefectMessages

type
  Channel = common.Channel

  ChannelPair* = common.ChannelPair

  ErrorMessages {.pure.} = enum
    Grad = "ncplane_gradient failed"
    Grad2x1 = "ncplane_gradient2x1 failed"
    PutStr = "ncplane_putstr failed"
    PutStrAligned = "ncplane_putstr_aligned failed"
    PutStrYx = "ncplane_putstr_yx failed"
    PutWc = "ncplane_putwc failed"
    Render = "notcurses_render failed"
    SetScroll = "ncplane_set_scrolling failed"

  InitProc = proc (opts: ptr notcurses_options, fp: File): ptr notcurses {.cdecl.}

  Input* = object
    cObj: ncinput

  Margins* = tuple[top, right, bottom, left: uint32]

  Notcurses* = object
    cPtr: ptr notcurses

  Options* = object
    cObj: notcurses_options

  Plane* = object
    cPtr: ptr ncplane

  PlaneDimensions* = tuple[y, x: uint32]

  TermDimensions* = tuple[rows, cols: uint32]

  # Aliases
  Nc* = Notcurses
  NcOpts* = Options

var
  ncApiObj {.threadvar.}: Notcurses
  ncExitProcAdded: Atomic[bool]
  ncPtr: Atomic[ptr notcurses]

func fmtPoint(point: uint32): string =
  let hex = point.uint64.toHex.strip(
    chars = {'0'}, trailing = false).toUpperAscii
  try:
    fmt"{hex:0>4}"
  except ValueError as e:
    raise (ref ApiDefect)(msg: e.msg)

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

proc get*(T: type Notcurses): T =
  if not isNcInited(): raise (ref ApiDefect)(msg: $NotcursesNotInitialized)
  ncApiObj

# for `notcurses_get`, etc. (i.e. abi calls that return 0'u32 on timeout), use
# Option none for timeout and Option some Codepoint otherwise
proc getBlocking*(nc: Notcurses, input: var Input) =
  discard nc.cPtr.notcurses_get_blocking(addr input.cObj)

func getScrolling*(plane: Plane): bool = plane.cPtr.ncplane_scrolling_p

proc gradient*(plane: Plane, y, x: int32, ylen, xlen: uint32, ul, ur, ll,
    lr: ChannelPair, egc = "", styles: varargs[Styles]):
    Result[ApiSuccess, ApiErrorCode] =
  var stylebits = 0'u32
  for s in styles[0..^1]:
    stylebits = bitor(stylebits, s.uint32)
  let code = plane.cPtr.ncplane_gradient(y, x, ylen, xlen, egc.cstring,
    stylebits.uint16, ul.uint64, ur.uint64, ll.uint64, lr.uint64)
  if code < 0:
    err ApiErrorCode(code: code, msg: $Grad)
  else:
    ok code

proc gradient2x1*(plane: Plane, y, x: int32, ylen, xlen: uint32, ul, ur, ll,
    lr: Channel): Result[ApiSuccess, ApiErrorCode] =
  let code = plane.cPtr.ncplane_gradient2x1(y, x, ylen, xlen, ul.uint32,
    ur.uint32, ll.uint32, lr.uint32)
  if code < 0:
    err ApiErrorCode(code: code, msg: $Grad2x1)
  else:
    ok code

func init*(T: type Channel, r, g, b: uint32): T =
  NCCHANNEL_INITIALIZER(r, g, b).T

func init*(T: type ChannelPair, fr, fg, fb, br, bg, bb: uint32): T =
  NCCHANNELS_INITIALIZER(fr, fg, fb, br, bg, bb).T

func init*(T: type Input): T = T(cObj: ncinput())

proc getBlocking*(nc: Notcurses): Input =
  var input = Input.init
  nc.getBlocking input
  input

func init*(T: type Margins, top = 0'u32, right = 0'u32, bottom = 0'u32,
    left = 0'u32): T =
  (top, right, bottom, left)

func init*(T: type Options, flags: openArray[InitFlags] = [], term = "",
    logLevel = LogLevels.Panic, margins = Margins.init): T =
  var fs = 0'u64
  for f in flags[0..^1]:
    fs = bitor(fs, f.uint64)
  var termtype: cstring
  if term != "": termtype = term.cstring
  let cObj = notcurses_options(termtype: termtype,
    loglevel: cast[ncloglevel_e](logLevel), margin_t: margins.top,
    margin_r: margins.right, margin_b: margins.bottom, margin_l: margins.left,
    flags: fs)
  T(cObj: cObj)

func key*(input: Input): Option[Keys] =
  let codepoint = input.codepoint
  if codepoint.uint32 in AllKeys: some cast[Keys](codepoint)
  else: none[Keys]()

proc putStr*(plane: Plane, s: string): Result[ApiSuccess, ApiErrorCode] =
  let code = plane.cPtr.ncplane_putstr s.cstring
  if code <= 0:
    err ApiErrorCode(code: code, msg: $PutStr)
  else:
    ok code

proc putStrAligned*(plane: Plane, s: string, alignment: Align, y = -1'i32):
    Result[ApiSuccess, ApiErrorCode] =
  let code = plane.cPtr.ncplane_putstr_aligned(y, cast[ncalign_e](alignment),
    s.cstring)
  if code <= 0:
    err ApiErrorCode(code: code, msg: $PutStrYx)
  else:
    ok code

proc putStrYx*(plane: Plane, s: string, y = -1'i32, x = -1'i32):
    Result[ApiSuccess, ApiErrorCode] =
  let code = plane.cPtr.ncplane_putstr_yx(y, x, s.cstring)
  if code <= 0:
    err ApiErrorCode(code: code, msg: $PutStrYx)
  else:
    ok code

proc putWc*(plane: Plane, wc: Wchar): Result[ApiSuccess, ApiErrorCode] =
  let code = plane.cPtr.ncplane_putwc wc
  if code < 0:
    err ApiErrorCode(code: code, msg: $PutWc)
  else:
    ok code

proc render*(nc: Notcurses): Result[void, ApiErrorCode] =
  let code = nc.cPtr.notcurses_render
  if code < 0:
    err ApiErrorCode(code: code, msg: $Render)
  else:
    ok()

proc setScrolling*(plane: Plane, enable: bool): bool =
  plane.cPtr.ncplane_set_scrolling enable.uint32

proc setStyles*(plane: Plane, styles: varargs[Styles]) =
  var stylebits = 0'u32
  for s in styles[0..^1]:
    stylebits = bitor(stylebits, s.uint32)
  plane.cPtr.ncplane_set_styles stylebits

proc stdDimYx*(nc: Notcurses, y, x: var uint32): Plane =
  let cPtr = nc.cPtr.notcurses_stddim_yx(addr y, addr x)
  Plane(cPtr: cPtr)

proc stdPlane*(nc: Notcurses): Plane =
  let cPtr = nc.cPtr.notcurses_stdplane
  Plane(cPtr: cPtr)

proc stop*(nc: Notcurses) =
  setNcStopping()
  if nc.cPtr.notcurses_stop < 0:
    raise (ref ApiDefect)(msg: $NotcursesFailedToStop)
  else:
    ncPtr.store(nil)
    ncApiObj = Notcurses()
    setNcStopped()

proc stopNotcurses() {.noconv.} = Notcurses.get.stop

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  import std/exitprocs
  template addExitProc(T: type Notcurses) =
    if not ncExitProcAdded.exchange(true): addExitProc stopNotcurses
else:
  template addExitProc(T: type Notcurses) =
    if not ncExitProcAdded.exchange(true): addQuitProc stopNotcurses

proc init*(T: type Notcurses, initProc: InitProc, options = Options.init,
    file = stdout, addExitProc = true): T =
  setNcIniting()
  var cOpts = options.cObj
  var cPtr: ptr notcurses
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: off.}
  try:
    cPtr = initProc(addr cOpts, file)
  except Exception:
    raise (ref ApiDefect)(msg: $NotcursesFailedToInitialize)
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: on.}
  if cPtr.isNil: raise (ref ApiDefect)(msg: $NotcursesFailedToInitialize)
  ncApiObj = T(cPtr: cPtr)
  ncPtr.store cPtr
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
  setNcInited()
  ncApiObj

func toBytes(buf: array[5, char]): seq[byte] =
  const nullC = '\x00'.char
  var bytes: seq[byte]
  bytes.add buf[0].byte
  for c in buf[1..3]:
    if c != nullC: bytes.add c.byte
    else: break
  bytes

func bytes(input: Input, skipHigh: bool): Option[seq[byte]] =
  # assumption: if `input.codepoint` is valid UCS32 then `input.cObj.utf8`
  # contains 1-4 bytes of a valid UTF-8 encoding
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
  # assumption: if `input.codepoint` is valid UCS32 then `input.bytes` contains
  # 1-4 bytes of a valid UTF-8 encoding
  if input.codepoint.uint32 <= HighUcs32.uint32:
    some string.fromBytes(input.bytes(true).get)
  else:
    none[string]()
