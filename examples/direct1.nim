import pkg/notcurses/direct
# or: import pkg/notcurses/direct/core

let ncd = Ncd.init NcdOpts.init [InitFlags.DrainInput]
ncd.putStr "Hello, Direct mode!\n"
ncd.stop
