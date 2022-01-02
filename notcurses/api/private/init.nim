proc init(T: type NotcursesOptions , options: varargs[NotcursesInitOptions]):
    T =
  var opts: culonglong
  if options.len == 0:
    opts = 0.culonglong
  elif options.len == 1:
    opts = options[0].culonglong
  else:
    opts = options[0].culonglong
    for o in options[1..^1]:
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
   ncObject
