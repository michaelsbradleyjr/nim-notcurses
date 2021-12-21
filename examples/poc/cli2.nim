import notcurses/raw

when isMainModule:
  const opts = ...

  let nc = notcurses_init ops

  notcurses_render nc
  notcurses_stop nc
