import notcurses/direct
# or: import notcurses/direct/core

let ncd = Ncd.init NcdOpts.init [InitFlags.DrainInput]

ncd.putStr("Hello, Direct mode!\n").expect
