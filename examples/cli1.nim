import pkg/notcurses
# or: import pkg/notcurses/core

let nc = Nc.init NcOpts.init [InitFlags.CliMode, DrainInput]
nc.stdPlane.putStr "Hello, Notcurses!\n"
nc.stop

# in Notcurses' CLI mode "\n" in a string triggers a render+scroll, one or more
# times depending on the number of times it's included

# there are one/more bugs in Notcurses affecting its CLI mode that result in
# incorrect scrolling/rendering, especially noticeable when init flag
# SuppressBanners is not used; possibly related to:
# https://github.com/dankamongmen/notcurses/issues/2196
