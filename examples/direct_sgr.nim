import std/strutils
import notcurses/direct/core
# or: import notcurses/direct

let ncd = Ncd.init NcdOptions.init [DirectDrainInput]

# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR
var e, i = 0'u32
while true:
  if bitand(ncd.supportedStyles.uint32, i) == i: ncd.setStyles(cast[NcStyles](i)).expect
  ncd.putStr(i.toHex.toLower & " ").expect
  ncd.setStyles(NcStyles.None).expect
  inc e
  if e mod 8 == 0: ncd.putStr("\n").expect
  inc i
  if i >= (NcStyles.Italic.uint32 shl 1): break
