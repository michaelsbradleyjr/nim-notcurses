proc init(T: type NotcursesOptions, options: varargs[NotcursesInitOptions],
    term = "", logLevel: NotcursesLogLevels = NotcursesLogLevels.Panic,
    marginTop: uint32 = 0, marginRight: uint32 = 0, marginBottom: uint32 = 0,
    marginLeft: uint32 = 0): T =
  var flags = 0.culonglong
  flags = bitor(flags, NotcursesInitOptions.NoAlternateScreen.culonglong)
  flags = bitor(flags, NotcursesInitOptions.NoClearBitmaps.culonglong)
  flags = bitor(flags, NotcursesInitOptions.PreserveCursor.culonglong)
  if options.len >= 1:
    for o in options[0..^1]:
      flags = bitor(flags, o.culonglong)
  if term == "":
    T(opts: notcurses_options(loglevel: cast[ncloglevel_e](logLevel),
      margin_t: marginTop.cuint, margin_r: marginRight.cuint,
      margin_b: marginBottom.cuint, margin_l: marginLeft.cuint, flags: flags))
  else:
    T(opts: notcurses_options(termtype: term.cstring,
      loglevel: cast[ncloglevel_e](logLevel), margin_t: marginTop.cuint,
      margin_r: marginRight.cuint, margin_b: marginBottom.cuint,
      margin_l: marginLeft.cuint, flags: flags))

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
