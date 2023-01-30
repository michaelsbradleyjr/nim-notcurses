import notcurses/direct/core
# or: import notcurses/direct

let ncd = Ncd.init NcdOptions.init DirectDrainInput

ncd.putStr("Do SGR stuff with Direct mode\n").expect
