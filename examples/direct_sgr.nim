import std/[sequtils, sets, strutils]
import pkg/notcurses/direct/core
# or: import pkg/notcurses/direct

# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR

let
  ncd = Ncd.init NcdOpts.init [InitFlags.DrainInput]
  supportedStyles = ncd.supportedStyles

var e, i = 0'u32
while i < (Styles.Italic.uint32 shl 1):
  let styles = ncd.supportedStyles(Style(i)).intersection supportedStyles
  ncd.setStyles styles.toSeq
  ncd.putStr i.uint64.toHex(8).toLower & " "
  ncd.setStyles Styles.None
  inc e
  if e mod 8 == 0: ncd.putStr "\n"
  inc i

ncd.stop
