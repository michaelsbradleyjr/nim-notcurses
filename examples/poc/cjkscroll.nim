import std/os
import notcurses/[cli, locale]

# locale can be set manually but it's generally not necessary because Notcurses
# attempts to do it automatically; this is just an example of using setlocale
setlocale(LC_ALL, "")

let
  # when locale was set manually the InhibitSetLocale option should be used
  opts = [DrainInput, InhibitSetLocale]
  nc = Nc.init NcOptions.init opts

Nc.addExitProc

var dimY, dimX: cuint

let n = nc.stdDimYX(dimY, dimX)

const
  start = 0x4e00.uint32
  stop  = 0x9fa5.uint32

var wc = start

n.putStr("\n").expect
nc.render.expect
n.setStyles(Bold)
n.putStr("This program is *not* indicative of real scrolling speed.").expect
n.setStyles(None)
n.putStr("\n\n").expect
nc.render.expect

while true:
  sleep 1
  n.putWc(cast[wchar_t](wc)).expect
  inc wc
  if wc == stop: wc = start
  nc.render.expect
