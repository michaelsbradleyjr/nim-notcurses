import std/[sequtils, strutils]
import pkg/notcurses/core
# or: import pkg/notcurses

let
  nc = Nc.init NcOpts.init [InitFlags.CliMode]
  stdn = nc.stdPlane

func fmtHex(bs: seq[byte]): string =
  var hex = ""
  for b in bs:
    let h = b.uint64.toHex(2).toUpperAscii
    hex &= " " & h
  hex.strip

proc put(s = "") = stdn.putStr(s).expect

proc putLn(s = "") = put s & "\n"

proc strike(s: string) =
  stdn.setStyles Styles.Struck
  put s
  stdn.setStyles Styles.None

while true:
  putLn()
  putLn "press any key or paste input, q to quit"
  putLn()

  let ni = nc.getBlocking
  var prefix: string

  putLn "event : " & $ni.event
  putLn "point : " & $ni.codepoint

  prefix = "key   : "
  let key = ni.key
  if key.isSome:
    put prefix & $key.get
  else:
    strike prefix
  putLn()

  prefix = "mods  : "
  let mods = ni.modifiers
  if mods.len > 0:
    put prefix & mods.mapIt($it).join(", ")
  else:
    strike prefix
  putLn()

  prefix = "utf8  : "
  let utf8 = ni.utf8
  if utf8.isSome:
    put prefix
    if stdn.putStr(utf8.get).isErr:
      put ReplacementChar
  else:
    strike prefix
  putLn()

  prefix = "bytes : "
  if utf8.isSome:
    put prefix & ni.bytes.get.fmtHex
  else:
    strike prefix
  putLn()

  if utf8.get("") == "q": break

nc.stop

# there are one/more bugs in Notcurses whereby, in some terminals, capability
# query data is sometimes leaking into user input at the start of the program;
# and in some terminals keypresses are spuriously being reported when
# e.g. focus is switched away from the OS window for the terminal
