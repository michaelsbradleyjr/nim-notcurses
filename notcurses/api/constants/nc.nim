import ../../abi/constants/nc

type
  Alignment* = distinct int32

  Align* {.pure.} = enum
    Unaligned = ncalign_e.NCALIGN_UNALIGNED.Alignment
    Left = ncalign_e.NCALIGN_LEFT.Alignment
    Center = ncalign_e.NCALIGN_CENTER.Alignment
    Right = ncalign_e.NCALIGN_RIGHT.Alignment

  InitFlag* = distinct uint64

  InitFlags* {.pure.} = enum
    InhibitSetlocale = NCOPTION_INHIBIT_SETLOCALE.InitFlag
    NoClearBitmaps = NCOPTION_NO_CLEAR_BITMAPS.InitFlag
    NoWinchSighandler = NCOPTION_NO_WINCH_SIGHANDLER.InitFlag
    NoQuitSighandlers = NCOPTION_NO_QUIT_SIGHANDLERS.InitFlag
    PreserveCursor = NCOPTION_PRESERVE_CURSOR.InitFlag
    SuppressBanners = NCOPTION_SUPPRESS_BANNERS.InitFlag
    NoAlternateScreen = NCOPTION_NO_ALTERNATE_SCREEN.InitFlag
    NoFontChanges = NCOPTION_NO_FONT_CHANGES.InitFlag
    DrainInput = NCOPTION_DRAIN_INPUT.InitFlag
    Scrolling = NCOPTION_SCROLLING.InitFlag
    CliMode = NCOPTION_CLI_MODE.InitFlag

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
