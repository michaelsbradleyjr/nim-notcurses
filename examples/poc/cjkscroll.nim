import std/os
import notcurses/[cli, locale]

setlocale(LC_ALL, "")

let
  opts = [DrainInput, InhibitSetLocale]
  nc = Nc.init NcOptions.init opts

Nc.addExitProc

var dimY, dimX: cuint

let n = nc.stdDimYX(dimY, dimX)

const start = 0x4e00.uint32
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
  n.putWc(wc).expect
  inc wc
  if wc == 0x9fa5.uint32: wc = start
  nc.render.expect
