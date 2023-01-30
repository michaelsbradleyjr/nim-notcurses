import notcurses/cli/core
# or: import notcurses/cli

let nc = Nc.init

# there are one/more bugs in Notcurses whereby, in some terminals, capability
# query data is leaking into user input at the start of the program; also,
# seemingly related, in some terminals keypresses are spuriously being reported
# when e.g. focus is switched from the OS window for the terminal to some other
# window, or to the OS menu bar, etc.

proc nop() {.noconv.} = discard
setControlCHook(nop)

# https://codepoints.net/U+FFFD?lang=en
const replacementChar = string.fromBytes hexToByteArray("0xEFBFBD", 3)

proc put(s = "") = nc.stdPlane.putStr(s).expect

proc put[T](v: Option[T]) =
  var s: string
  if v.isSome: s = $v.get
  else: s = $v
  put s

proc putLn(s = "") = put s & "\n"

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
  put "key   : "
  putLn key

  let utf8 = ni.toUTF8
  put "utf8  : "

  if utf8.isSome:
    let res = nc.stdPlane.putStr utf8.get & "\n"
    if res.isErr: putLn replacementChar
  else:
    putLn $utf8

  putLn "input : " & $ni

  if utf8.get("") == "q": break

blankLn()
