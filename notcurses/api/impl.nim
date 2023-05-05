when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[bitops, macros, options, strformat, strutils]
import pkg/stew/[byteutils, results]
import ../abi/impl
import ./common
import ./constants

export Time, Timespec, options
export common except ApiDefect, PseudoCodepoint, contains
export constants except AllKeys, DefectMessages

type
  Channel = common.Channel

  ErrorMessages {.pure.} = enum
    Grad = "ncplane_gradient failed"
    Grad2x1 = "ncplane_gradient2x1 failed"
    PutStr = "ncplane_putstr failed"
    PutStrAligned = "ncplane_putstr_aligned failed"
    PutStrYx = "ncplane_putstr_yx failed"
    PutWc = "ncplane_putwc failed"
    Render = "notcurses_render failed"
    SetScroll = "ncplane_set_scrolling failed"

  Init = proc (opts: ptr notcurses_options, fp: File): ptr notcurses {.cdecl.}

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


func fmtPoint(point: uint32): string =
  let hex = point.uint64.toHex.strip(
    chars = {'0'}, trailing = false).toUpperAscii
  try:
    fmt"{hex:0>4}"
  except ValueError as e:
    raise (ref ApiDefect)(msg: e.msg)

func `$`*(codepoint: Codepoint): string =
  let hex = codepoint.fmtPoint
  var pri, sec: string
  if codepoint <= HighUcs32:
    pri = "U+"
    if codepoint in AllKeys: sec = "NCKEY+"
  elif codepoint in AllKeys:
    pri = "NCKEY+"
  if pri == "" and sec == "":
    raise (ref ApiDefect)(msg: $InvalidCodepoint & " " & hex)
  pri & hex & (if sec != "": " | " & sec & hex else: "")

func `$`*(input: Input): string = $input.cObj

func `$`*(options: Options): string = $options.cObj

func `$`*(codepoint: Ucs32): string =
  let hex = codepoint.fmtPoint
  if codepoint > HighUcs32:
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
  let iflags = @flags
  var flags = 0'u64
  for f in iflags[0..^1]:
    flags = bitor(flags, f.uint64)
  var termtype: cstring
  if term != "": termtype = term.cstring
  let cObj = notcurses_options(termtype: termtype,
    loglevel: cast[ncloglevel_e](logLevel), margin_t: margins.top,
    margin_r: margins.right, margin_b: margins.bottom, margin_l: margins.left,
    flags: flags)
  T(cObj: cObj)

proc init*(T: type Notcurses, init: Init, options = Options.init,
    file = stdout): T =
  var
    cOpts = options.cObj
    cPtr: ptr notcurses
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: off.}
  try:
    cPtr = init(addr cOpts, file)
  except Exception:
    raise (ref ApiDefect)(msg: $NotcursesFailedToInitialize)
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: on.}
  if cPtr.isNil: raise (ref ApiDefect)(msg: $NotcursesFailedToInitialize)
  T(cPtr: cPtr)

func key*(input: Input): Option[Keys] =
  let codepoint = input.codepoint
  if codepoint in AllKeys: some cast[Keys](codepoint)
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
  if nc.cPtr.notcurses_stop < 0:
    raise (ref ApiDefect)(msg: $NotcursesFailedToStop)

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
  if skipHigh or (input.codepoint <= HighUcs32):
    some input.cObj.utf8.toBytes
  else:
    none[seq[byte]]()

func bytes*(input: Input): Option[seq[byte]] = input.bytes(false)

func toCodepoint*(u: PseudoCodepoint | Ucs32): Option[Codepoint] =
  if (u <= HighUcs32) or (u in AllKeys): some u.Codepoint
  else: none[Codepoint]()

func toUcs32*(u: Codepoint | PseudoCodepoint): Option[Ucs32] =
  if u <= HighUcs32: some u.Ucs32
  else: none[Ucs32]()

func toUtf8*(codepoint: Codepoint | Ucs32): Option[string] =
  if codepoint > HighUcs32: none[string]()
  else:
    var
      buf: array[5, char]
      u = codepoint.uint32
    let code = notcurses_ucs32_to_utf8(addr u, 1,
      cast[ptr UncheckedArray[char]](addr buf), 5)
    if code >= 0: some string.fromBytes(buf.toBytes)
    else: none[string]()

func utf8*(input: Input): Option[string] =
  # assumption: if `input.codepoint` is valid UCS32 then `input.bytes` contains
  # 1-4 bytes of a valid UTF-8 encoding
  if input.codepoint <= HighUcs32:
    some string.fromBytes(input.bytes(true).get)
  else:
    none[string]()
