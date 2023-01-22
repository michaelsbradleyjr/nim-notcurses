import notcurses/cli
# or: import notcurses/cli/core

let
  nc = Nc.init
  stdn = nc.stdPlane

proc nop() {.noconv.} = discard
setControlCHook(nop)

# https://codepoints.net/U+FFFD?lang=en
const replacementChar = string.fromBytes hexToByteArray("0xEFBFBD", 3)

proc put(s: string = "") = stdn.putStr(s).expect

proc put[T](v: Option[T]) =
  var s: string
  if v.isSome: s = $v.get
  else: s = $v
  put s

proc putLn(s: string = "") = put s & "\n"

proc putLn[T](v: Option[T]) =
  var s: string
  if v.isSome: s = $v.get
  else: s = $v
  putLn s

proc blankLn() = putLn()

while true:
  blankLn()
  putLn "press any key, q to quit"

  let ni = nc.getBlocking
  blankLn()
  putLn "event : " & $ni.event
  putLn "point : " & $ni.codepoint

  let key = ni.toKey
  put   "key   : "
  putLn key

  let utf8 = ni.toUTF8
  put "utf8  : "

  if utf8.isSome:
    let res = stdn.putStr utf8.get & "\n"
    if res.isErr: putLn replacementChar
  else:
    putLn $utf8

  putLn "input : " & $ni

  if utf8.get("") == "q": break

blankLn()
