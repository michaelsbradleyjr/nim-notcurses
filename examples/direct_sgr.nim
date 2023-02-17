import std/strutils
import notcurses/direct/core
# or: import notcurses/direct

let ncd = Ncd.init NcdOptions.init [DirectDrainInput]

# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR

func style(i: uint32): Styles = cast[Styles](i)

proc supported(i: uint32): bool = bitand(ncd.supportedStyles.uint32, i) == i

var e, i = 0'u32
while i < (Italic.uint32 shl 1):
  if i.supported: ncd.setStyles(i.style).expect
  ncd.putStr(i.toHex.toLower & " ").expect
  ncd.setStyles(None).expect
  inc e
  if e mod 8 == 0: ncd.putStr("\n").expect
  inc i
