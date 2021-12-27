# import notcurses/cli

# The Nim compiler can rely on ../pkg.cfg (--path setting) to load unprefixed
# notcurses. However, some tools, e.g. nimlsp in combo with Emacs lsp-mode, can
# (currently) fail to handle nim.cfg correctly, in which case missing symbols,
# etc. may be reported in one's editor; it's preferable to import relative
# paths while developing with tools suffering such limitations.
import ../../notcurses/cli

# get rid of this
import os

let
  nc = Nc.init
  stdn = nc.stdPlane

template putAndRender(s: typed) =
  stdn.putStr(s).expect
  nc.render.expect

template blankLine() =
  putAndRender "\n"

# get rid of this
var counter = 0

blankLine()
while true:
  putAndRender "press any key, q to quit\n"
  # let ni = nc.getBlocking
  # if ni.eventType != NCTYPE_RELEASE or ni.id == 'q': break

  # get rid of this
  sleep 1000
  counter += 1
  if counter >= 10: break
blankLine()

nc.stop.expect
