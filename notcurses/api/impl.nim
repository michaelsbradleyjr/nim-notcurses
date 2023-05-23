when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[bitops, macros, sequtils, sets, strformat, strutils]
import pkg/stew/[byteutils, results]
import ../abi/impl
import ./common
import ./constants

export Time, Timespec
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

func fmtPoint(point: Codepoint | PseudoCodepoint | Ucs32): string =
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

func `$`*(input: Input): string =
  $input.cObj

func `$`*(options: Options): string =
  $options.cObj

func `$`*(codepoint: Ucs32): string =
  let hex = codepoint.fmtPoint
  if codepoint > HighUcs32:
    raise (ref ApiDefect)(msg: $InvalidUcs32 & " " & hex)
  "U+" & hex

func codepoint*(input: Input): Codepoint =
  Codepoint(input.cObj.id)

func cursorY*(plane: Plane): uint32 =
  plane.cPtr.ncplane_cursor_y

proc dimYx*(plane: Plane, y, x: var uint32) =
  plane.cPtr.ncplane_dim_yx(addr y, addr x)

proc dimYx*(plane: Plane): PlaneDimensions =
  var y, x: uint32
  plane.dimYx(y, x)
  (y, x)

func event*(input: Input): InputEvents =
  cast[InputEvents](input.cObj.evtype)

# for `notcurses_get`, etc. (i.e. abi calls that return 0'u32 on timeout), use
# `Opt.none Codepoint` for timeout and `Opt.some [codepoint]` otherwise

# possibly need to wrap output in Result and return error if
# notcurses_get_blocking returns high(uint32)
proc getBlocking*(nc: Notcurses, input: var Input): Codepoint {.discardable.} =
  Codepoint(nc.cPtr.notcurses_get_blocking(addr input.cObj))

func getScrolling*(plane: Plane): bool =
  plane.cPtr.ncplane_scrolling_p

proc gradient*(plane: Plane, y, x: int32, ylen, xlen: uint32, ul, ur, ll,
    lr: ChannelPair, egc = "", styles: varargs[Styles]):
    Result[ApiSuccess, ApiErrorCode] {.discardable.} =
  let
    styles = styles.foldl(bitor(a, b.uint32), 0'u32)
    code = plane.cPtr.ncplane_gradient(y, x, ylen, xlen, egc.cstring,
      styles.uint16, ul.uint64, ur.uint64, ll.uint64, lr.uint64)
  if code < 0:
    err ApiErrorCode(code: code, msg: $Grad)
  else:
    ok code

proc gradient2x1*(plane: Plane, y, x: int32, ylen, xlen: uint32, ul, ur, ll,
    lr: Channel): Result[ApiSuccess, ApiErrorCode] {.discardable.} =
  let code = plane.cPtr.ncplane_gradient2x1(y, x, ylen, xlen, ul.uint32,
    ur.uint32, ll.uint32, lr.uint32)
  if code < 0:
    err ApiErrorCode(code: code, msg: $Grad2x1)
  else:
    ok code

func init*(T: typedesc[Channel], r, g, b: uint32): T =
  T(NCCHANNEL_INITIALIZER(r, g, b))

func init*(T: typedesc[ChannelPair], fr, fg, fb, br, bg, bb: uint32): T =
  T(NCCHANNELS_INITIALIZER(fr, fg, fb, br, bg, bb))

func init*(T: typedesc[Input]): T =
  T(cObj: ncinput())

# possibly need to wrap output in Result and return error if
# notcurses_get_blocking returns high(uint32)
proc getBlocking*(nc: Notcurses): Input =
  var input = Input.init
  discard nc.getBlocking input
  input

func init*(T: typedesc[Margins], top = 0'u32, right = 0'u32, bottom = 0'u32,
    left = 0'u32): T =
  (top, right, bottom, left)

func init*(T: typedesc[Options], flags: openArray[InitFlags] = [], term = "",
    logLevel = LogLevels.Panic, margins = Margins.init): T =
  let flags = flags.foldl(bitor(a, b.uint64), 0'u64)
  var termtype: cstring
  if term != "": termtype = term.cstring
  let cObj = notcurses_options(termtype: termtype,
    loglevel: cast[ncloglevel_e](logLevel), margin_t: margins.top,
    margin_r: margins.right, margin_b: margins.bottom, margin_l: margins.left,
    flags: flags)
  T(cObj: cObj)

proc init*(T: typedesc[Notcurses], init: Init, initName: string,
    options = Options.init, file = stdout): T =
  var
    cOpts = options.cObj
    cPtr: ptr notcurses
  let failedMsg = initName & " failed"
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: off.}
  try:
    cPtr = init(addr cOpts, file)
  except Exception:
    raise (ref ApiDefect)(msg: failedMsg)
  when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
    {.warning[BareExcept]: on.}
  if cPtr.isNil: raise (ref ApiDefect)(msg: failedMsg)
  T(cPtr: cPtr)

macro init*(T: typedesc[Notcurses], init: Init, options = Options.init,
    file = stdout): Notcurses =
  let name = init.strVal
  quote do: `T`.init(`init`, `name`, `options`, `file`)

func key*(input: Input): Opt[Keys] =
  let codepoint = input.codepoint
  if codepoint in AllKeys: Opt.some cast[Keys](codepoint)
  else: Opt.none Keys

# modifiers field for ncinput was introduced in Notcurses v3.0.4, which would
# be a problem re: the type declaration in abi/impl when linking against
# earlier versions of the library ... any good way to work around that?
# maybe it's not such a problem if doing header-less importc?
# in that case, maybe this func can emulate evaluating the modifiers field if
# at runtime Notcurses version is < 3.0.4, i.e. by computing with older bool
# fields alt, shift, control
func modifiersMask*(input: Input): KeyModifier =
  KeyModifier(input.cObj.modifiers)

# see comment above re: modifiers field
func modifiers*(input: Input,
    mask = input.modifiersMask): HashSet[KeyModifiers] =
  var mods: HashSet[KeyModifiers]
  for m in [KeyModifiers.Shift, Alt, Ctrl, Super, Hyper, Meta,
      KeyModifiers.CapsLock, KeyModifiers.NumLock]:
    if bitand(mask.uint32, m.uint32) == m.uint32:
      mods.incl m
  mods

proc putStr*(plane: Plane, s: string): Result[ApiSuccess, ApiErrorCode]
    {.discardable.} =
  let code = plane.cPtr.ncplane_putstr s.cstring
  if code <= 0:
    err ApiErrorCode(code: code, msg: $PutStr)
  else:
    ok code

proc putStrAligned*(plane: Plane, s: string, alignment: Align, y = -1'i32):
    Result[ApiSuccess, ApiErrorCode] {.discardable.} =
  let code = plane.cPtr.ncplane_putstr_aligned(y, cast[ncalign_e](alignment),
    s.cstring)
  if code <= 0:
    err ApiErrorCode(code: code, msg: $PutStrAligned)
  else:
    ok code

proc putStrYx*(plane: Plane, s: string, y = -1'i32, x = -1'i32):
    Result[ApiSuccess, ApiErrorCode] {.discardable.} =
  let code = plane.cPtr.ncplane_putstr_yx(y, x, s.cstring)
  if code <= 0:
    err ApiErrorCode(code: code, msg: $PutStrYx)
  else:
    ok code

proc putWc*(plane: Plane, wc: Wchar): Result[ApiSuccess, ApiErrorCode]
    {.discardable.} =
  let code = plane.cPtr.ncplane_putwc wc
  if code < 0:
    err ApiErrorCode(code: code, msg: $PutWc)
  else:
    ok code

proc render*(nc: Notcurses): Result[void, ApiErrorCode] {.discardable.} =
  let code = nc.cPtr.notcurses_render
  if code < 0:
    err ApiErrorCode(code: code, msg: $Render)
  else:
    ok()

proc setScrolling*(plane: Plane, enable: bool): bool =
  plane.cPtr.ncplane_set_scrolling enable.uint32

proc setStyles*(plane: Plane, styles: varargs[Styles]) =
  let styles = styles.foldl(bitor(a, b.uint32), 0'u32)
  plane.cPtr.ncplane_set_styles styles

proc stdDimYx*(nc: Notcurses, y, x: var uint32): Plane =
  let cPtr = nc.cPtr.notcurses_stddim_yx(addr y, addr x)
  Plane(cPtr: cPtr)

proc stdPlane*(nc: Notcurses): Plane =
  let cPtr = nc.cPtr.notcurses_stdplane
  Plane(cPtr: cPtr)

proc stop*(nc: Notcurses) =
  if nc.cPtr.notcurses_stop < 0:
    raise (ref ApiDefect)(msg: $NcStop)

func toBytes(buf: array[5, char]): seq[byte] =
  const nullC = '\x00'.char
  var bytes: seq[byte]
  bytes.add buf[0].byte
  for c in buf[1..3]:
    if c != nullC: bytes.add c.byte
    else: break
  bytes

func bytes(input: Input, skipHigh: bool): Opt[seq[byte]] =
  # assumption: if `input.codepoint` is valid UCS32 then `input.cObj.utf8`
  # contains 1-4 bytes of a valid UTF-8 encoding
  if skipHigh or (input.codepoint <= HighUcs32):
    Opt.some input.cObj.utf8.toBytes
  else:
    Opt.none seq[byte]

func bytes*(input: Input): Opt[seq[byte]] =
  input.bytes(false)

func toCodepoint*(u: PseudoCodepoint | Ucs32): Opt[Codepoint] =
  if (u <= HighUcs32) or (u in AllKeys): Opt.some Codepoint(u)
  else: Opt.none Codepoint

func toUcs32*(u: Codepoint | PseudoCodepoint): Opt[Ucs32] =
  if u <= HighUcs32: Opt.some Ucs32(u)
  else: Opt.none Ucs32

func toUtf8*(codepoint: Codepoint | Ucs32): Opt[string] =
  if codepoint > HighUcs32: Opt.none string
  else:
    var
      buf: array[5, char]
      u = codepoint.uint32
    let code = notcurses_ucs32_to_utf8(addr u, 1,
      cast[ptr UncheckedArray[char]](addr buf), 5)
    if code >= 0: Opt.some string.fromBytes(buf.toBytes)
    else: Opt.none string

func utf8*(input: Input): Opt[string] =
  # assumption: if `input.codepoint` is valid UCS32 then `input.bytes` contains
  # 1-4 bytes of a valid UTF-8 encoding
  if input.codepoint <= HighUcs32:
    Opt.some string.fromBytes(input.bytes(true).get)
  else:
    Opt.none string
