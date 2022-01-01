type
  DefectMessages* {.pure.} = enum
    AlreadyInitialized = "Notcurses is already initialized!"
    FailedToInitialize = "Notcurses failed to initialize!"
    FailureNotExpected = "failure not expected"
    NotInitialized = "Notcurses is not initialized!"

  ErrorMessages* {.pure.} = enum
    PutStr = "Notcurses.putStr failed!"
    Render = "Notcurses.render failed!"
    Stop = "Notcurses.stop failed!"

  InitOption* = distinct culonglong

  InitOptions* {.pure.} = enum
    InhibitSetlocale = NCOPTION_INHIBIT_SETLOCALE.InitOption,
    NoClearBitmaps = NCOPTION_NO_CLEAR_BITMAPS.InitOption,
    NoWinchSighandler = NCOPTION_NO_WINCH_SIGHANDLER.InitOption,
    NoQuitSighandlers = NCOPTION_NO_QUIT_SIGHANDLERS.InitOption,
    PreserveCursor = NCOPTION_PRESERVE_CURSOR.InitOption,
    SuppressBanners = NCOPTION_SUPPRESS_BANNERS.InitOption,
    NoAlternateScreen = NCOPTION_NO_ALTERNATE_SCREEN.InitOption,
    NoFontChanges = NCOPTION_NO_FONT_CHANGES.InitOption,
    DrainInput = NCOPTION_DRAIN_INPUT.InitOption
