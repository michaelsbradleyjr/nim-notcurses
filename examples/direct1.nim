import notcurses/direct
# or: import notcurses/direct/core

let ncd = Ncd.init NcdOptions.init [InitOptions.DrainInput]

ncd.putStr("Hello, Direct mode!\n").expect
