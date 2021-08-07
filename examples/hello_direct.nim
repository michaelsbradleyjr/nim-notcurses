import # notcurses lib
  notcurses/[core/direct, locale]

setlocale(LC_ALL, "")

var nc = ncdirect_core_init(nil, stdout, NCDIRECT_OPTION_INHIBIT_CBREAK)

discard nc.ncdirect_set_fg_default

for r in 0..16:
  for g in 0..16:
    for b in 0..16:
      var
        rr = r * 16
        gg = g * 16
        bb = b * 16

      if rr > 255: rr = 255
      if gg > 255: gg = 255
      if bb > 255: bb = 255

      discard nc.ncdirect_set_fg_rgb(
        (rr shl 16).cuint + (gg shl 8).cuint + bb.cuint)

      stdout.write "Hello"

      if r + g + b == 48:
        stdout.write "\n"
      else:
        stdout.write " "

      stdout.flushFile

discard nc.ncdirect_stop
