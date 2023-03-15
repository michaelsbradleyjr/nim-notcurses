import std/strutils
import notcurses/cli/core
# or: import notcurses/cli

let
  nc = Nc.init
  stdn = nc.stdPlane

proc nop() {.noconv.} = discard
setControlCHook(nop)

proc put(s = "") = stdn.putStr(s).expect

proc putLn(s = "") = put s & "\n"

proc blankLn() = putLn()

func fmtHex(x: seq[byte]): string =
  var hex = ""
  for b in x:
    let f = b.uint64.toHex(2).toUpperAscii
    hex &= " " & f
  hex.strip

while true:
  blankLn()
  putLn "paste input or press any key, q to quit"
  blankLn()

  let ni = nc.getBlocking
  putLn "event : " & $ni.event
  putLn "point : " & $ni.codepoint

  let key = ni.key
  if key.isNone: stdn.setStyles(Struck)
  put "key   : " & (if key.isSome: $key.get else: "")
  stdn.setStyles(None)
  put "\n"

  var prefix = "utf8  : "
  let utf8 = ni.utf8
  if utf8.isSome:
    put prefix
    let res = stdn.putStr utf8.get
    if res.isErr: put ReplacementChar
  else:
    stdn.setStyles(Struck)
    put prefix
    stdn.setStyles(None)
  put "\n"

  prefix = "bytes : "
  if utf8.isSome:
    put prefix & ni.bytes.get.fmtHex
  else:
    stdn.setStyles(Struck)
    put prefix
    stdn.setStyles(None)
  put "\n"

  if utf8.get("") == "q": break

# there are one/more bugs in Notcurses whereby, in some terminals, capability
# query data is sometimes leaking into user input at the start of the program;
# and in some terminals keypresses are spuriously being reported when
# e.g. focus is switched away from the OS window for the terminal
