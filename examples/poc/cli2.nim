import notcurses

when isMainModule:
  let
    opts = Options.init(NCOPTION_NO_ALTERNATE_SCREEN, NCOPTION_PRESERVE_CURSOR,
      NCOPTION_NO_CLEAR_BITMAPS, NCOPTION_DRAIN_INPUT)

    nc = Notcurses.init opts

  nc.notcurses_render
  nc.notcurses_stop
