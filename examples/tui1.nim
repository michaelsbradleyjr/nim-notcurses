import notcurses
# or: import notcurses/core

let nc = Nc.init

proc nop() {.noconv.} = discard
setControlCHook(nop)

# in Notcurses' TUI mode (its default mode, i.e. *not* CLI mode or Direct mode)
# Nim's stack traces can be swallowed if printed to stderr before `nc.stop` has
# run; the most practical workaround is to redirect stderr to a log file and
# then tail that file in another terminal:
# `$ tail -F tui1.log`
# `$ examples/tui1 2> tui1.log`

# in Notcurses' TUI mode \n in a string causes putStr/YX to fail
nc.stdPlane.putStr("Hello").expect # cursor advanced in x with y=0
nc.stdPlane.putStr(", Notcurses!").expect # cursor advanced in x but still y=0
nc.stdPlane.putStrYX("press q", 2, 0).expect # cursor advanced in y/x, now y=2
nc.stdPlane.putStr(" to quit").expect # cursor advanced in x with y=2
nc.render.expect
while true:
  if nc.getBlocking.toUTF8.get("") == "q": break
