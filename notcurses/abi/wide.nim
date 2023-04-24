when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[bitops, macros, typetraits]

const
  wchar_header = "<wchar.h>"
  wchar_t = "wchar_t"

# wchar_t is implementation-defined so use of that type as specified below may
# produce incorrect results on some platforms
when defined(windows):
  # https://learn.microsoft.com/en-us/windows/win32/midl/wchar-t
  type Wchar* {.header: wchar_header, importc: wchar_t.} = distinct cushort
else:
  type Wchar* {.header: wchar_header, importc: wchar_t.} = distinct cuint

template wchar*(u: untyped): Wchar = u.Wchar

proc wcwidth*(wc: Wchar): cint {.cdecl, header: wchar_header, importc.}

# adapted from: https://stackoverflow.com/a/148766
func toSeqB*(s: openArray[Wchar]): seq[byte] =
  var
    c: distinctBase(Wchar)
    codepoint: uint32
    i = 0
    bytes: seq[byte]
  while true:
    c = distinctBase(Wchar)(s[i])
    if c == 0:
      break
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
        bytes.add bitor(0xc0.uint32, bitand(codepoint shr 6, 0x1f)).byte
        bytes.add bitor(0x80.uint32, bitand(codepoint, 0x3f)).byte
      elif codepoint <= 0xffff:
        bytes.add bitor(0xe0.uint32, bitand(codepoint shr 12, 0x0f)).byte
        bytes.add bitor(0x80.uint32, bitand(codepoint shr 6, 0x3f)).byte
        bytes.add bitor(0x80.uint32, bitand(codepoint, 0x3f)).byte
      else:
        bytes.add bitor(0xf0.uint32, bitand(codepoint shr 18, 0x07)).byte
        bytes.add bitor(0x80.uint32, bitand(codepoint shr 12, 0x3f)).byte
        bytes.add bitor(0x80.uint32, bitand(codepoint shr 6, 0x3f)).byte
        bytes.add bitor(0x80.uint32, bitand(codepoint, 0x3f)).byte
      codepoint = 0
    inc i
  bytes

# adapted from: https://stackoverflow.com/a/148766
func toSeqDbW*(s: string, l: int): seq[distinctBase(Wchar)] =
  var
    c = 0'u8
    codepoint: uint32
    i = 0
    codes: seq[distinctBase(Wchar)]
  while true:
    if i == l:
      codes.add 0
      break
    c = s[i].uint8
    if c <= 0x7f:
      codepoint = c
    elif c <= 0xbf:
      codepoint = bitor(codepoint shl 6, bitand(c, 0x3f))
    elif c <= 0xdf:
      codepoint = bitand(c, 0x1f)
    elif c <= 0xef:
      codepoint = bitand(c, 0x0f)
    else:
      codepoint = bitand(c, 0x07)
    inc i
    if i == l:
      c = 0
    else:
      c = s[i].uint8
    if (bitand(c, 0xc0) != 0x80) and (codepoint <= 0x10ffff):
      when sizeof(Wchar) > 2:
        codes.add distinctBase(Wchar)(codepoint)
      else:
        if codepoint > 0xffff:
          codepoint = codepoint - 0x10000
          codes.add distinctBase(Wchar)(0xd800 + (codepoint shr 10))
          codes.add distinctBase(Wchar)(0xdc00 + bitand(codepoint, 0x03ff))
        elif (codepoint < 0xd800) or (codepoint >= 0xe000):
          codes.add distinctBase(Wchar)(codepoint)
  codes

# https://en.cppreference.com/w/c/language/string_literal
macro L*(s: static string): untyped =
  # debugEcho s
  result = newStmtList()
  let
    toArrayW = genSym(nskProc, "toArrayW")
    codes = toSeqDbW(s, s.len)
    l = codes.len
  result.add quote do:
    func `toArrayW`(): array[`l`, Wchar] {.compileTime.} =
      var a: array[`l`, Wchar]
      for i, codepoint in `codes`:
        a[i] = codepoint.wchar
      a
    `toArrayW`()
  # debugEcho toStrLit(result)
