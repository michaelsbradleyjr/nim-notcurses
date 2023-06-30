{.push raises: [].}

import std/[bitops, macros, typetraits]
import pkg/stew/byteutils

const
  wchar_header = "<wchar.h>"
  wchar_t = "wchar_t"

when defined(coverage):
  import ./coverage
  macro wide(procedure: untyped): untyped =
    result = quote do:
      coverageWrapper(`procedure`, wchar_header)
else:
  {.pragma: wide, cdecl, header: wchar_header, importc.}

# wchar_t is implementation-defined so use of that type as specified below may
# produce incorrect results on some platforms
when defined(windows):
  # https://learn.microsoft.com/en-us/windows/win32/midl/wchar-t
  type Wchar* {.header: wchar_header, importc: wchar_t.} = distinct cushort
else:
  type Wchar* {.header: wchar_header, importc: wchar_t.} = distinct cuint

type DbW = distinctBase(Wchar)

func `==`*(x, y: Wchar): bool =
  DbW(x) == DbW(y)

template wchar*(u: untyped): Wchar =
  Wchar(u)

proc wcwidth*(wc: Wchar): cint {.wide.}

# adapted from: https://stackoverflow.com/a/148766
func toSeqB*(ws: ptr UncheckedArray[Wchar]): seq[byte] =
  when not (DbW is cuint or DbW is cushort):
    # `when` branch was added for defining `type Wchar` but is not accounted
    # for in `toSeqB`
    {.fatal: "unexpected base type for Wchar: " & $distinctBase(Wchar).}
  var
    c = DbW(0)
    codepoint = 0'u32
    i = 0
    bytes: seq[byte]
  while true:
    c = DbW(ws[][i])
    if c == 0: break
    elif (c >= 0xd800) and (c <= 0xdbff):
      codepoint = ((c - 0xd800).uint32 shl 10) + 0x10000
    else:
      if (c >= 0xdc00) and (c <= 0xdfff):
        codepoint = bitor(codepoint, (c - 0xdc00).uint32)
      else:
        codepoint = c.uint32
      if codepoint <= 0x7f:
        bytes.add codepoint.byte
      elif codepoint <= 0x7ff:
        bytes.add bitor(0xc0'u32, bitand(codepoint shr 6, 0x1f)).byte
        bytes.add bitor(0x80'u32, bitand(codepoint, 0x3f)).byte
      elif codepoint <= 0xffff:
        bytes.add bitor(0xe0'u32, bitand(codepoint shr 12, 0x0f)).byte
        bytes.add bitor(0x80'u32, bitand(codepoint shr 6, 0x3f)).byte
        bytes.add bitor(0x80'u32, bitand(codepoint, 0x3f)).byte
      else:
        bytes.add bitor(0xf0'u32, bitand(codepoint shr 18, 0x07)).byte
        bytes.add bitor(0x80'u32, bitand(codepoint shr 12, 0x3f)).byte
        bytes.add bitor(0x80'u32, bitand(codepoint shr 6, 0x3f)).byte
        bytes.add bitor(0x80'u32, bitand(codepoint, 0x3f)).byte
      codepoint = 0
    inc i
  bytes

func toSeqB*(ws: openArray[Wchar]): seq[byte] =
  toSeqB cast[ptr UncheckedArray[Wchar]](unsafeAddr ws[0])

# adapted from: https://stackoverflow.com/a/148766
func toSeqW*(s: string): seq[Wchar] =
  let
    bs = s.toBytes
    l = bs.len
  var
    b = 0'u8
    codepoint = 0'u32
    codes: seq[DbW]
    i = 0
  while true:
    if i == l: break
    b = bs[i]
    if b <= 0x7f:
      codepoint = b
    elif b <= 0xbf:
      codepoint = bitor(codepoint shl 6, bitand(b, 0x3f))
    elif b <= 0xdf:
      codepoint = bitand(b, 0x1f)
    elif b <= 0xef:
      codepoint = bitand(b, 0x0f)
    else:
      codepoint = bitand(b, 0x07)
    inc i
    if i == l:
      b = 0
    else:
      b = bs[i]
    if (bitand(b, 0xc0) != 0x80) and (codepoint <= 0x10ffff):
      when DbW is cuint:
        codes.add DbW(codepoint)
      elif DbW is cushort:
        if codepoint > 0xffff:
          codepoint = codepoint - 0x10000
          codes.add DbW(0xd800 + (codepoint shr 10))
          codes.add DbW(0xdc00 + bitand(codepoint, 0x03ff))
        elif (codepoint < 0xd800) or (codepoint >= 0xe000):
          codes.add DbW(codepoint)
      else:
        # `when` branch was added for defining `type Wchar` but is not
        # accounted for in `toSeqW`
        {.fatal: "unexpected base type for Wchar: " & $distinctBase(Wchar).}
  when nimvm:
    var wcs: seq[Wchar]
    for c in codes:
      wcs.add c.wchar
    wcs
  else:
    cast[seq[Wchar]](codes)

# https://en.cppreference.com/w/c/language/string_literal
macro L*(s: static string): untyped =
  # debugEcho s
  result = newStmtList()
  var wcs = toSeqW s
  wcs.add 0.wchar
  let
    l = wcs.len
    toArrayW = genSym(nskProc, "toArrayW")
  result.add quote do:
    func `toArrayW`(): array[`l`, Wchar] {.compileTime.} =
      var ws: array[`l`, Wchar]
      for i, wc in `wcs`:
        # when (NimMajor, NimMinor) < (2, 0):
        when (NimMajor, NimMinor, NimPatch) < (1, 9, 3):
          ws[i] = wc.wchar
        else:
          ws[i] = wc
      ws
    `toArrayW`()
  # debugEcho toStrLit(result)
