import notcurses
# or: import notcurses/core

let nc = Nc.init

proc nop() {.noconv.} = discard
setControlCHook(nop)

# in Notcurses' TUI mode (its default mode) Nim's stack traces can be
# effectively swallowed when printed to stderr just before `nc.stop` is
# triggered; the most practical workaround for dev/debug purposes is to
# redirect stderr to a log file and then tail that file in another terminal:
# `$ tail -F tui1.log`
# `$ examples/tui1 2> tui1.log`

nc.stdPlane.putStr("Hello, Notcurses!").expect # cursor advanced in x with y=0
nc.stdPlane.putStrYx("press q to quit", 2, 0).expect
nc.render.expect

while nc.getBlocking.utf8.get("") != "q": discard
