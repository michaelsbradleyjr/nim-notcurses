import std/[bitops, sequtils, strformat, strutils, tables]
import pkg/notcurses/abi/core
# or: import pkg/notcurses/abi
import pkg/stew/byteutils
import ./nckeys

var opts = notcurses_options(flags: NCOPTION_CLI_MODE)

let nc = notcurses_core_init(addr opts, stdout)
if nc.isNil: raise (ref Defect)(msg: "notcurses_core_init failed")

# or: let nc = notcurses_init(addr opts, stdout)
# or: if nc.isNil: raise (ref Defect)(msg: "notcurses_init failed")

let stdn = notcurses_stdplane nc

const
  HighUcs32 = 0x0010ffff'u32

  ReplacementChar* = string.fromBytes hexToByteArray("0xefbfbd", 3)

func bytes(input: ncinput): seq[byte] =
  const nullC = '\x00'.char
  var bytes: seq[byte]
  bytes.add input.utf8[0].byte
  for c in input.utf8[1..3]:
    if c != nullC: bytes.add c.byte
    else: break
  bytes

func fmtHex(bs: seq[byte]): string =
  bs.foldl(a & " " & b.uint64.toHex(2).toUpperAscii, "").strip

func fmtHex(codepoint: uint32): string =
  let hex = codepoint.uint64.toHex.strip(
    chars = {'0'}, trailing = false).toUpperAscii
  fmt"{hex:0>4}"

func fmtPoint(codepoint: uint32): string =
  let hex = codepoint.fmtHex
  var pri, sec: string
  if codepoint <= HighUcs32:
    pri = "U+"
    if codepoint in NcKeys: sec = "NCKEY+"
  elif codepoint in NcKeys:
    pri = "NCKEY+"
  if pri == "" and sec == "":
    raise (ref Defect)(msg: "invalid codepoint " & hex)
  pri & hex & (if sec != "": " | " & sec & hex else: "")

func isKey(codepoint: uint32): bool = codepoint in NcKeys

func isUtf8(codepoint: uint32): bool = codepoint <= HighUcs32

func mods(ni: ncinput): seq[string] =
  var mods: seq[string]
  for m in NcKeyMods.keys:
    if bitand(ni.modifiers, m) == m:
      mods.add NcKeyMods[m]
  mods

proc put(s = "") = discard ncplane_putstr(stdn, s.cstring)

proc putLn(s = "") = put s & "\n"

proc strike(s: string) =
  ncplane_set_styles(stdn, NCSTYLE_STRUCK)
  put s
  ncplane_set_styles(stdn, NCSTYLE_NONE)

func toKeyName(codepoint: uint32): string = NcKeys[codepoint]

func toUtf8(input: ncinput): string = string.fromBytes(input.bytes)

while true:
  putLn()
  putLn "press any key or paste input, q to quit"
  putLn()

  var ni: ncinput
  let codepoint = notcurses_get_blocking(nc, addr ni)

  putLn "event : " & $ni.evtype
  putLn "point : " & codepoint.fmtPoint

  var prefix: string

  prefix = "key   : "
  if codepoint.isKey:
    put prefix & codepoint.toKeyName
  else:
    strike prefix
  putLn()

  prefix = "mods  : "
  let mods = ni.mods
  if mods.len > 0:
    put prefix & mods.join(", ")
  else:
    strike prefix
  putLn()

  prefix = "utf8  : "
  if codepoint.isUtf8:
    let utf8 = ni.toUtf8
    put prefix
    if ncplane_putstr(stdn, utf8.cstring) <= 0:
      put ReplacementChar
  else:
    strike prefix
  putLn()

  prefix = "bytes : "
  if codepoint.isUtf8:
    put prefix & ni.bytes.fmtHex
  else:
    strike prefix
  putLn()

  if codepoint == 'q'.uint32: break

if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "notcurses_stop failed")
