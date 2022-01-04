import notcurses/cli
# or: import notcurses/core/cli

let
  nc = Nc.init
  stdn = nc.stdPlane

addNcExitProc()

proc putAndRender(s: string) =
  stdn.putStr(s & "\n").expect
  nc.render.expect

proc blankLine() =
  putAndRender ""

while true:
  blankLine()
  putAndRender   "press any key, q to quit"
  let ni = nc.getBlocking

  blankLine()
  putAndRender   "event : " & $ni.event
  putAndRender   "point : " & $ni.codepoint

  let key = ni.toKey
  if key.isSome:
    putAndRender "key   : " & $key.get
  else:
    putAndRender "key   : " & $key

  let utf8 = ni.toUTF8
  if utf8.isSome:
    (stdn.putStr "utf8  : ").expect
    stdn.putStr(utf8.get).expect
    stdn.putStr("\n").expect
    nc.render.expect
  else:
    putAndRender "utf8  : " & $utf8

  putAndRender   "obj   : " & $ni

  if ni.toUTF8.get("") == "q": break

blankLine()
