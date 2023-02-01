import notcurses/cli
# or: import notcurses/cli/core

let nc = Nc.init NcOptions.init [DrainInput]

# there are one/more bugs in Notcurses affecting its CLI mode that result in
# incorrect scrolling/rendering, especially noticeable when init option
# SuppressBanners is not used
#
# possibly related to https://github.com/dankamongmen/notcurses/issues/2196

# in Notcurses' CLI mode \n in a string triggers a render, one or more times
# depending on the number of times it's included
nc.stdPlane.putStr("Hello, Notcurses!\n").expect
