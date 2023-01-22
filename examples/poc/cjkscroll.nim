import std/os
import notcurses/[cli, locale]

# locale can be set manually but it's generally not necessary because Notcurses
# attempts to do it automatically; this is just an example of using setLocale
setLocale(LC_ALL, "").expect

let
  # if locale was set manually then the InhibitSetLocale option can be used
  # when initializing Notcurses
  opts = [DrainInput, InhibitSetLocale]
  nc = Nc.init NcOptions.init opts
  stdn = nc.stdPlane

Nc.addExitProc

# https://codepoints.net/cjk_unified_ideographs
const
  first = 0x4e00
  last  = 0x9fa5

var wc = first

stdn.setStyles(Bold)
stdn.putStr("\nThis program is *not* indicative of real scrolling speed.\n\n").expect
stdn.setStyles(None)

while true:
  sleep 1
  stdn.putWc(cast[wchar_t](wc)).expect
  inc wc
  if wc == last: wc = first
  nc.render.expect
