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

  # get rid of this
  putAndRender   "isKey  : " & $ni.isKey
  putAndRender   "isKey  : " & $ni.codepoint.isKey
  putAndRender   "isUTF8 : " & $ni.isUTF8
  putAndRender   "isUTF8 : " & $ni.codepoint.isUTF8

  putAndRender   "event : " & $ni.event
  putAndRender   "point : " & $ni.codepoint

  let key = ni.toKey
  if key.isSome:
    putAndRender "key   : " & $key.get
  else:
    putAndRender "key   : " & $key

  let utf8 = ni.toUTF8
  if utf8.isSome:
    var str = ""
    if ni.codepoint.uint32 < 128:
      addEscapedChar(str, ni.codepoint.char)
    else:
      str = str & utf8.get
    putAndRender "utf8  : " & str
  else:
    putAndRender "utf8  : " & $utf8

  putAndRender   "obj   : " & $ni

  if ni.toUTF8.get("") == "q": break

blankLine()
