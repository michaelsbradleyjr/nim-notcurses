import # std libs
  std/os

import # notcurses lib
  notcurses/[core, locale]

setlocale(LC_ALL, "")

var
  nc = notcurses_core_init(nil, stdout)

# do something interesting after figuring out what that is and how to do it

sleep(3000)

discard notcurses_stop(nc)
