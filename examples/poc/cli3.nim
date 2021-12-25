# import notcurses

# The Nim compiler can rely on ../pkg.cfg (--path setting) to load unprefixed
# notcurses. However, some tools, e.g. nimlsp in combo with Emacs lsp-mode, can
# (currently) fail to handle nim.cfg correctly, in which case missing symbols,
# etc. may be reported in one's editor; it's preferable to import relative
# paths while developing with tools suffering such limitations.
import ../../notcurses

let
  opts = [DrainInput, NoClearBitmaps, PreserveCursor]
  nc = Notcurses.init NotcursesOptions.init(opts)

nc.render.expect()
nc.stop.expect()
