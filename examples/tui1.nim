import pkg/notcurses
# or: import pkg/notcurses/core

let nc = Nc.init

discard nc.stdPlane.putStr("Hello, Notcurses!") # cursor advanced in x with y=0
discard nc.stdPlane.putStrYx("press q to quit", 2, 0)
nc.render.expect

while nc.getBlocking.codepoint != 'q': discard

nc.stop

# in Notcurses' TUI mode (its default mode) Nim's stack traces can be
# effectively swallowed when printed to stderr just before Notcurses shutdown;
# the most practical workaround for dev/debug purposes is to redirect stderr to
# a log file and then tail that file in another terminal:
# `$ tail -F tui1.log`
# `$ examples/tui1 2> tui1.log`
