import # std libs
  std/random

import # notcurses lib
  notcurses/[core/direct, locale]

const
  Greetings = 255
  Hello = "Hello"

proc rrgb(): cuint =
  let
    r = (rand Greetings).cuint
    g = (rand Greetings).cuint
    b = (rand Greetings).cuint

  (r shl 16) + (g shl 8) + b

when isMainModule:
  randomize()
  setlocale(LC_ALL, "")
  setStdIoUnbuffered()

  let nc = ncdirect_core_init(nil, stdout, NCDIRECT_OPTION_INHIBIT_CBREAK)

  discard nc.ncdirect_set_bg_default
  discard nc.ncdirect_set_fg_default

  discard nc.ncdirect_set_bg_rgb rrgb()

  var
    i = 0
    j = 0

  # `except: discard` below provides naive "retry logic" in case of
  # e.g. EAGAIN; however, even with retries on all exceptions, what's written
  # to stdout isn't always what's expected, may see e.g. "Hel Hello". It's
  # unclear at present why that happens and how to fix it.

  while i <= Greetings:
    try:
      discard nc.ncdirect_set_fg_rgb rrgb()

      while j <= Hello.len:
        try:
          if j < Hello.len:
            stdout.write Hello[j]
          else:
            var sep = " "

            if i == Greetings:
              sep = "\n"
              discard nc.ncdirect_set_bg_default
              discard nc.ncdirect_set_fg_default

            stdout.write sep

          j = j + 1

        except: discard

      i = i + 1
      j = 0

    except: discard

  discard nc.ncdirect_stop
