proc init(T: type NotcursesOptions, options: varargs[NotcursesInitOptions]):
    T =
  var opts = 0.culonglong
  opts = bitor(opts, NotcursesInitOptions.NoAlternateScreen.culonglong)
  opts = bitor(opts, NotcursesInitOptions.NoClearBitmaps.culonglong)
  opts = bitor(opts, NotcursesInitOptions.PreserveCursor.culonglong)
  if options.len >= 1:
    for o in options[0..^1]:
      opts = bitor(opts, o.culonglong)
  T(opts: notcurses_options(flags: opts))

proc init(T: type Notcurses, opts: NotcursesOptions = NotcursesOptions.init,
    file: File = stdout): T =
  if not ncObject.ncPtr.isNil or not ncPtr.load.isNil:
    raise (ref NotcursesDefect)(msg: $AlreadyInitialized)
  else:
    let ncP = notcurses_init(unsafeAddr opts.opts, file)
    if ncP.isNil: raise (ref NotcursesDefect)(msg: $FailedToInitialize)
    ncObject = T(ncPtr: ncP)
    if not ncPtr.exchange(ncObject.ncPtr).isNil:
      raise (ref NotcursesDefect)(msg: $AlreadyInitialized)
    ncObject.stdPlane.setScrolling true
    ncObject
