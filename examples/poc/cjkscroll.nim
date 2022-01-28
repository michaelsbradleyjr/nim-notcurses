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
  first = 0x4e00
  last  = 0x9fa5

var wc = first

n.putStr("\n").expect
nc.render.expect
n.setStyles(Bold)
n.putStr("This program is *not* indicative of real scrolling speed.").expect
nc.render.expect
n.setStyles(None)
n.putStr("\n\n").expect
nc.render.expect

while true:
  sleep 1
  n.putWc(wc.Utf16Char).expect
  inc wc
  if wc == last: wc = first
  nc.render.expect
