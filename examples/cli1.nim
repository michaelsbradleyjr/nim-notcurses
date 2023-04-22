import notcurses
# or: import notcurses/core

let nc = Nc.init NcOptions.init [InitOptions.CliMode, InitOptions.DrainInput]

nc.stdPlane.putStr("Hello, Notcurses!\n").expect

# in Notcurses' CLI mode '\n' in a string triggers a render+scroll, one or more
# times depending on the number of times it's included

# there are one/more bugs in Notcurses affecting its CLI mode that result in
# incorrect scrolling/rendering, especially noticeable when init option
# SuppressBanners is not used; possibly related to:
# https://github.com/dankamongmen/notcurses/issues/2196
