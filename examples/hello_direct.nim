import # std libs
  std/random

import # notcurses lib
  notcurses/[core/direct, locale]

randomize()
setlocale(LC_ALL, "")

proc rrgb(): cuint =
  let
    r = (rand 255).cuint
    g = (rand 255).cuint
    b = (rand 255).cuint

  (r shl 16) + (g shl 8) + b

let nc = ncdirect_core_init(nil, stdout, NCDIRECT_OPTION_INHIBIT_CBREAK)

discard nc.ncdirect_set_bg_default
discard nc.ncdirect_set_fg_default

discard nc.ncdirect_set_bg_rgb rrgb()

for n in 0..255:
  discard nc.ncdirect_set_fg_rgb rrgb()

  stdout.write "Hello"

  if n == 255:
    discard nc.ncdirect_set_bg_default
    discard nc.ncdirect_set_fg_default
    stdout.write "\n"
  else:
    stdout.write " "

  stdout.flushFile

discard nc.ncdirect_stop
