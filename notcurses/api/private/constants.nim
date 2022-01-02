type
  NotcursesDefectMessages {.pure.} = enum
    AlreadyInitialized = "Notcurses is already initialized!"
    FailedToInitialize = "Notcurses failed to initialize!"
    FailureNotExpected = "failure not expected"
    NotInitialized = "Notcurses is not initialized!"

  NotcursesErrorMessages {.pure.} = enum
    PutStr = "Notcurses.putStr failed!"
    Render = "Notcurses.render failed!"
    Stop = "Notcurses.stop failed!"

  NotcursesInitOption = distinct culonglong

  NotcursesInitOptions {.pure.} = enum
    InhibitSetlocale = NCOPTION_INHIBIT_SETLOCALE.NotcursesInitOption,
    NoClearBitmaps = NCOPTION_NO_CLEAR_BITMAPS.NotcursesInitOption,
    NoWinchSighandler = NCOPTION_NO_WINCH_SIGHANDLER.NotcursesInitOption,
    NoQuitSighandlers = NCOPTION_NO_QUIT_SIGHANDLERS.NotcursesInitOption,
    PreserveCursor = NCOPTION_PRESERVE_CURSOR.NotcursesInitOption,
    SuppressBanners = NCOPTION_SUPPRESS_BANNERS.NotcursesInitOption,
    NoAlternateScreen = NCOPTION_NO_ALTERNATE_SCREEN.NotcursesInitOption,
    NoFontChanges = NCOPTION_NO_FONT_CHANGES.NotcursesInitOption,
    DrainInput = NCOPTION_DRAIN_INPUT.NotcursesInitOption
