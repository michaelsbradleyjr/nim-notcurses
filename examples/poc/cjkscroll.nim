import std/os
import notcurses/[cli, locale]
# or: import notcurses/[cli/core, locale]

# locale can be set manually but it's generally not necessary because Notcurses
# attempts to do it automatically; this is just an example of using setLocale
setLocale(LC_ALL, "").expect

let
  # if locale was set manually then pass InhibitSetLocale option to init
  opts = [DrainInput, InhibitSetLocale]
  nc = Nc.init(NcOptions.init opts, addExitProc = false)
  stdn = nc.stdPlane

proc stop() {.noconv.} =
  stdn.putStr("\n\n").expect
  nc.stop.expect
  quit(QuitSuccess)

setControlCHook(stop)

# https://codepoints.net/cjk_unified_ideographs
const
  first = 0x4e00
  last = 0x9fff

var wc = first

# see comment in ./cli1.nim re: scrolling/rendering bugs
stdn.setStyles(Bold)
stdn.putStr("\nThis program is *not* indicative of real scrolling speed.\n\n").expect
stdn.setStyles(None)

while true:
  sleep 10
  stdn.putWc(wc.wchar_t).expect
  # rendering after each putWc() isn't necessary but it makes auto-scroll
  # behavior of Notcurses' CLI mode visually more apparent
  nc.render.expect
  inc wc
  if wc > last: wc = first
