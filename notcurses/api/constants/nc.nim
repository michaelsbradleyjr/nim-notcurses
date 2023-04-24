import ../../abi/constants/nc

type
  Alignment* = distinct int32

  Align* {.pure.} = enum
    Unaligned = ncalign_e.NCALIGN_UNALIGNED.Alignment
    Left = ncalign_e.NCALIGN_LEFT.Alignment
    Center = ncalign_e.NCALIGN_CENTER.Alignment
    Right = ncalign_e.NCALIGN_RIGHT.Alignment

  InitOption* = distinct uint64

  InitOptions* {.pure.} = enum
    InhibitSetlocale = NCOPTION_INHIBIT_SETLOCALE.InitOption
    NoClearBitmaps = NCOPTION_NO_CLEAR_BITMAPS.InitOption
    NoWinchSighandler = NCOPTION_NO_WINCH_SIGHANDLER.InitOption
    NoQuitSighandlers = NCOPTION_NO_QUIT_SIGHANDLERS.InitOption
    PreserveCursor = NCOPTION_PRESERVE_CURSOR.InitOption
    SuppressBanners = NCOPTION_SUPPRESS_BANNERS.InitOption
    NoAlternateScreen = NCOPTION_NO_ALTERNATE_SCREEN.InitOption
    NoFontChanges = NCOPTION_NO_FONT_CHANGES.InitOption
    DrainInput = NCOPTION_DRAIN_INPUT.InitOption
    Scrolling = NCOPTION_SCROLLING.InitOption
    CliMode = NCOPTION_CLI_MODE.InitOption

  InputEvent* = distinct int32

  InputEvents* {.pure.} = enum
    Unknown = ncintype_e.NCTYPE_UNKNOWN.InputEvent
    Press = ncintype_e.NCTYPE_PRESS.InputEvent
    Repeat = ncintype_e.NCTYPE_REPEAT.InputEvent
    Release = ncintype_e.NCTYPE_RELEASE.InputEvent

  LogLevel* = distinct int32

  LogLevels* {.pure.} = enum
    Silent = ncloglevel_e.NCLOGLEVEL_SILENT.LogLevel
    Panic = ncloglevel_e.NCLOGLEVEL_PANIC.LogLevel
    Fatal = ncloglevel_e.NCLOGLEVEL_FATAL.LogLevel
    Error = ncloglevel_e.NCLOGLEVEL_ERROR.LogLevel
    Warning = ncloglevel_e.NCLOGLEVEL_WARNING.LogLevel
    Info = ncloglevel_e.NCLOGLEVEL_INFO.LogLevel
    Verbose = ncloglevel_e.NCLOGLEVEL_VERBOSE.LogLevel
    Debug = ncloglevel_e.NCLOGLEVEL_DEBUG.LogLevel
    Trace = ncloglevel_e.NCLOGLEVEL_TRACE.LogLevel
