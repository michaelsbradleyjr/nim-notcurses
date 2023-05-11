import ../../abi/constants/nc

type
  Alignment* = distinct int32

  Align* {.pure.} = enum
    Unaligned = Alignment(ncalign_e.NCALIGN_UNALIGNED)
    Left = Alignment(ncalign_e.NCALIGN_LEFT)
    Center = Alignment(ncalign_e.NCALIGN_CENTER)
    Right = Alignment(ncalign_e.NCALIGN_RIGHT)

  InitFlag* = distinct uint64

  InitFlags* {.pure.} = enum
    InhibitSetlocale = InitFlag(NCOPTION_INHIBIT_SETLOCALE)
    NoClearBitmaps = InitFlag(NCOPTION_NO_CLEAR_BITMAPS)
    NoWinchSighandler = InitFlag(NCOPTION_NO_WINCH_SIGHANDLER)
    NoQuitSighandlers = InitFlag(NCOPTION_NO_QUIT_SIGHANDLERS)
    PreserveCursor = InitFlag(NCOPTION_PRESERVE_CURSOR)
    SuppressBanners = InitFlag(NCOPTION_SUPPRESS_BANNERS)
    NoAlternateScreen = InitFlag(NCOPTION_NO_ALTERNATE_SCREEN)
    NoFontChanges = InitFlag(NCOPTION_NO_FONT_CHANGES)
    DrainInput = InitFlag(NCOPTION_DRAIN_INPUT)
    Scrolling = InitFlag(NCOPTION_SCROLLING)
    CliMode = InitFlag(NCOPTION_CLI_MODE)

  InputEvent* = distinct int32

  InputEvents* {.pure.} = enum
    Unknown = InputEvent(ncintype_e.NCTYPE_UNKNOWN)
    Press = InputEvent(ncintype_e.NCTYPE_PRESS)
    Repeat = InputEvent(ncintype_e.NCTYPE_REPEAT)
    Release = InputEvent(ncintype_e.NCTYPE_RELEASE)

  LogLevel* = distinct int32

  LogLevels* {.pure.} = enum
    Silent = LogLevel(ncloglevel_e.NCLOGLEVEL_SILENT)
    Panic = LogLevel(ncloglevel_e.NCLOGLEVEL_PANIC)
    Fatal = LogLevel(ncloglevel_e.NCLOGLEVEL_FATAL)
    Error = LogLevel(ncloglevel_e.NCLOGLEVEL_ERROR)
    Warning = LogLevel(ncloglevel_e.NCLOGLEVEL_WARNING)
    Info = LogLevel(ncloglevel_e.NCLOGLEVEL_INFO)
    Verbose = LogLevel(ncloglevel_e.NCLOGLEVEL_VERBOSE)
    Debug = LogLevel(ncloglevel_e.NCLOGLEVEL_DEBUG)
    Trace = LogLevel(ncloglevel_e.NCLOGLEVEL_TRACE)
