proc init*(T: type NotcursesOptions , options: varargs[InitOptions]): T =
  var opts = 0.culonglong
  opts = bitor(opts, NoAlternateScreen.culonglong)
  opts = bitor(opts, NoClearBitmaps.culonglong)
  opts = bitor(opts, PreserveCursor.culonglong)
  if options.len == 1:
    opts = bitor(opts, options[0].culonglong)
  elif options.len > 1:
    for o in options[1..^1]:
      opts = bitor(opts, o.culonglong)
  T(opts: notcurses_options(flags: opts))

proc init*(T: type Notcurses, opts: NotcursesOptions = NotcursesOptions.init,
    file: File = stdout): T =
  if not ncObject.ncPtr.isNil or not ncPtr.load.isNil:
    raise (ref NotcursesDefect)(msg: $DefectMessages.AlreadyInitialized)
  else:
    let ncP = notcurses_init(unsafeAddr opts.opts, file)
    if ncP.isNil: raise (ref NotcursesDefect)(
      msg: $DefectMessages.FailedToInitialize)
    ncObject = T(ncPtr: ncP)
    if not ncPtr.exchange(ncObject.ncPtr).isNil:
      raise (ref NotcursesDefect)(msg: $DefectMessages.AlreadyInitialized)
    ncObject.stdPlane.setScrolling true
    ncObject
