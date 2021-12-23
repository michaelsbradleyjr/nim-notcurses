# import notcurses

# should be able to depend on --path in nim.cfg but nimlsp and/or Emacs
# lsp-mode doesn't (always?) handle it correctly, so import with relative paths
# instead when developing with those tools

import ../../notcurses

let
  opts = [DrainInput, NoAlternateScreen, NoClearBitmaps, PreserveCursor]
  nc = Notcurses.init Options.init(opts)

discard nc.render
discard nc.stop
