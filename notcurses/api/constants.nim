type
  DefectMessages {.pure.} = enum
    AddExitProcFailed =
      when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
        "addExitProc raised an unknown exception"
      else:
        "addQuitProc raised an unknown exception"
    AlreadyInitialized = "Notcurses is already initialized"
    AlreadyStopped = "Notcurses is already stopped"
    FailedToInitialize = "Notcurses failed to initialize"
    FailureNotExpected = "failure not expected"
    NotInitialized = "Notcurses is not initialized"

  DirectInitOption* = distinct uint64

  DirectInitOptions* {.pure.} = enum
    DirectInhibitSetlocale = NCDIRECT_OPTION_INHIBIT_SETLOCALE
    DirectInhibitCbreak = NCDIRECT_OPTION_INHIBIT_CBREAK
    DirectDrainInput = NCDIRECT_OPTION_DRAIN_INPUT
    DirectNoQuitSighandlers = NCDIRECT_OPTION_NO_QUIT_SIGHANDLERS
    DirectVerbose = NCDIRECT_OPTION_VERBOSE
    DirectVeryVerbose = NCDIRECT_OPTION_VERY_VERBOSE

  ErrorMessages {.pure.} = enum
    DirectPutStr = "ncdirect_putstr failed"
    DirectStop = "ncdirect_stop failed"
    Grad = "ncplane_gradient failed"
    Grad2x1 = "ncplane_gradient2x1 failed"
    PutStr = "ncplane_putstr failed"
    PutStrYX = "ncplane_putstr_yx failed"
    PutWc = "ncplane_putwc failed"
    Render = "notcurses_render failed"
    SetScroll = "ncplane_set_scrolling failed"
    Stop = "notcurses_stop failed"

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

  Key* = distinct uint32

  Keys* {.pure.} = enum
    Tab = NCKEY_TAB.Key
    Esc = NCKEY_ESC.Key
    Space = NCKEY_SPACE.Key
    Invalid = NCKEY_INVALID.Key
    Resize = NCKEY_RESIZE.Key
    Up = NCKEY_UP.Key
    Right = NCKEY_RIGHT.Key
    Down = NCKEY_DOWN.Key
    Left = NCKEY_LEFT.Key
    Ins = NCKEY_INS.Key
    Del = NCKEY_DEL.Key
    Backspace = NCKEY_BACKSPACE.Key
    PgDown = NCKEY_PGDOWN.Key
    PgUp = NCKEY_PGUP.Key
    Home = NCKEY_HOME.Key
    End = NCKEY_END.Key
    F00 = NCKEY_F00.Key
    F01 = NCKEY_F01.Key
    F02 = NCKEY_F02.Key
    F03 = NCKEY_F03.Key
    F04 = NCKEY_F04.Key
    F05 = NCKEY_F05.Key
    F06 = NCKEY_F06.Key
    F07 = NCKEY_F07.Key
    F08 = NCKEY_F08.Key
    F09 = NCKEY_F09.Key
    F10 = NCKEY_F10.Key
    F11 = NCKEY_F11.Key
    F12 = NCKEY_F12.Key
    F13 = NCKEY_F13.Key
    F14 = NCKEY_F14.Key
    F15 = NCKEY_F15.Key
    F16 = NCKEY_F16.Key
    F17 = NCKEY_F17.Key
    F18 = NCKEY_F18.Key
    F19 = NCKEY_F19.Key
    F20 = NCKEY_F20.Key
    F21 = NCKEY_F21.Key
    F22 = NCKEY_F22.Key
    F23 = NCKEY_F23.Key
    F24 = NCKEY_F24.Key
    F25 = NCKEY_F25.Key
    F26 = NCKEY_F26.Key
    F27 = NCKEY_F27.Key
    F28 = NCKEY_F28.Key
    F29 = NCKEY_F29.Key
    F30 = NCKEY_F30.Key
    F31 = NCKEY_F31.Key
    F32 = NCKEY_F32.Key
    F33 = NCKEY_F33.Key
    F34 = NCKEY_F34.Key
    F35 = NCKEY_F35.Key
    F36 = NCKEY_F36.Key
    F37 = NCKEY_F37.Key
    F38 = NCKEY_F38.Key
    F39 = NCKEY_F39.Key
    F40 = NCKEY_F40.Key
    F41 = NCKEY_F41.Key
    F42 = NCKEY_F42.Key
    F43 = NCKEY_F43.Key
    F44 = NCKEY_F44.Key
    F45 = NCKEY_F45.Key
    F46 = NCKEY_F46.Key
    F47 = NCKEY_F47.Key
    F48 = NCKEY_F48.Key
    F49 = NCKEY_F49.Key
    F50 = NCKEY_F50.Key
    F51 = NCKEY_F51.Key
    F52 = NCKEY_F52.Key
    F53 = NCKEY_F53.Key
    F54 = NCKEY_F54.Key
    F55 = NCKEY_F55.Key
    F56 = NCKEY_F56.Key
    F57 = NCKEY_F57.Key
    F58 = NCKEY_F58.Key
    F59 = NCKEY_F59.Key
    F60 = NCKEY_F60.Key
    Enter = NCKEY_ENTER.Key
    Cls = NCKEY_CLS.Key
    DLeft = NCKEY_DLEFT.Key
    DRight = NCKEY_DRIGHT.Key
    ULeft = NCKEY_ULEFT.Key
    URight = NCKEY_URIGHT.Key
    Center = NCKEY_CENTER.Key
    Begin = NCKEY_BEGIN.Key
    Cancel = NCKEY_CANCEL.Key
    Close = NCKEY_CLOSE.Key
    Command = NCKEY_COMMAND.Key
    Copy = NCKEY_COPY.Key
    Exit = NCKEY_EXIT.Key
    Print = NCKEY_PRINT.Key
    Refresh = NCKEY_REFRESH.Key
    Separator = NCKEY_SEPARATOR.Key
    CapsLock = NCKEY_CAPS_LOCK.Key
    ScrollLock = NCKEY_SCROLL_LOCK.Key
    NumLock = NCKEY_NUM_LOCK.Key
    PrintScreen = NCKEY_PRINT_SCREEN.Key
    Pause = NCKEY_PAUSE.Key
    Menu = NCKEY_MENU.Key
    MediaPlay = NCKEY_MEDIA_PLAY.Key
    MediaPause = NCKEY_MEDIA_PAUSE.Key
    MediaPPause = NCKEY_MEDIA_PPAUSE.Key
    MediaRev = NCKEY_MEDIA_REV.Key
    MediaStop = NCKEY_MEDIA_STOP.Key
    MediaFF = NCKEY_MEDIA_FF.Key
    MediaRewind = NCKEY_MEDIA_REWIND.Key
    MediaNext = NCKEY_MEDIA_NEXT.Key
    MediaPrev = NCKEY_MEDIA_PREV.Key
    MediaRecord = NCKEY_MEDIA_RECORD.Key
    MediaLVol = NCKEY_MEDIA_LVOL.Key
    MediaRVol = NCKEY_MEDIA_RVOL.Key
    MediaMute = NCKEY_MEDIA_MUTE.Key
    LShift = NCKEY_LSHIFT.Key
    LCtrl = NCKEY_LCTRL.Key
    LAlt = NCKEY_LALT.Key
    LSuper = NCKEY_LSUPER.Key
    LHyper = NCKEY_LHYPER.Key
    LMeta = NCKEY_LMETA.Key
    RShift = NCKEY_RSHIFT.Key
    RCtrl = NCKEY_RCTRL.Key
    RAlt = NCKEY_RALT.Key
    RSuper = NCKEY_RSUPER.Key
    RHyper = NCKEY_RHYPER.Key
    RMeta = NCKEY_RMETA.Key
    L3Shift = NCKEY_L3SHIFT.Key
    L5Shift = NCKEY_L5SHIFT.Key
    Motion = NCKEY_MOTION.Key
    Button1 = NCKEY_BUTTON1.Key
    Button2 = NCKEY_BUTTON2.Key
    Button3 = NCKEY_BUTTON3.Key
    Button4 = NCKEY_BUTTON4.Key
    Button5 = NCKEY_BUTTON5.Key
    Button6 = NCKEY_BUTTON6.Key
    Button7 = NCKEY_BUTTON7.Key
    Button8 = NCKEY_BUTTON8.Key
    Button9 = NCKEY_BUTTON9.Key
    Button10 = NCKEY_BUTTON10.Key
    Button11 = NCKEY_BUTTON11.Key
    Signal = NCKEY_SIGNAL.Key
    EOF = NCKEY_EOF.Key

const
  ScrollUp* = Keys.Button4
  ScrollDown* = Keys.Button5
  Return* = Keys.Enter

type
  KeyModifier* = distinct int32

  KeyModifiers* {.pure.} = enum
    Shift = NCKEY_MOD_SHIFT.KeyModifier
    Alt = NCKEY_MOD_ALT.KeyModifier
    Ctrl = NCKEY_MOD_CTRL.KeyModifier
    Super = NCKEY_MOD_SUPER.KeyModifier
    Hyper = NCKEY_MOD_HYPER.KeyModifier
    Meta = NCKEY_MOD_META.KeyModifier
    CapsLock = NCKEY_MOD_CAPSLOCK.KeyModifier
    NumLock = NCKEY_MOD_NUMLOCK.KeyModifier

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

  Style* = distinct uint32

  Styles* {.pure.} = enum
    None = NCSTYLE_NONE.Style
    Struck = NCSTYLE_STRUCK.Style
    Bold = NCSTYLE_BOLD.Style
    Undercurl = NCSTYLE_UNDERCURL.Style
    Underline = NCSTYLE_UNDERLINE.Style
    Italic = NCSTYLE_ITALIC.Style
    Mask = NCSTYLE_MASK.Style
