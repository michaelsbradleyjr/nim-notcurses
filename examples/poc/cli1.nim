import notcurses/cli
# or: import notcurses/core/cli

let
  nc = Nc.init
  stdn = nc.stdPlane

addNcExitProc()

proc render() = nc.render.expect

proc put(s: string = "") =
  stdn.putStr(s).expect
  render()

proc put[T](v: Option[T]) =
  var s: string
  if v.isSome: s = $v.get
  else: s = $v
  put s

proc putLn(s: string = "") =
  put s & "\n"
  render()

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

  put   "utf8  : "
  put   utf8
  putLn()

  putLn "input : " & $ni

  if utf8.get("") == "q": break

blankLn()
