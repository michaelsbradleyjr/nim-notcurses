import std/strutils
import notcurses/direct/core
# or: import notcurses/direct

# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR

let ncd = Ncd.init NcdOpts.init [InitFlags.DrainInput]

func style(i: uint32): Styles = cast[Styles](i)

proc supported(i: uint32): bool = (ncd.supportedStyles.uint32 and i) == i

var e, i = 0'u32
while i < (Styles.Italic.uint32 shl 1):
  if i.supported: ncd.setStyles(i.style).expect
  ncd.putStr(i.uint64.toHex(8).toLower & " ").expect
  ncd.setStyles(Styles.None).expect
  inc e
  if e mod 8 == 0: ncd.putStr("\n").expect
  inc i
