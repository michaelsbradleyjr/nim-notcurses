type
  NotcursesDefectMessages {.pure.} = enum
    AlreadyAdded       = "Notcurses exit proc is already added!"
    AlreadyInitialized = "Notcurses is already initialized!"
    AlreadyStopped     = "Notcurses is already stopped!"
    FailedToInitialize = "Notcurses failed to initialize!"
    FailureNotExpected = "failure not expected"
    NotInitialized     = "Notcurses is not initialized!"

  NotcursesErrorMessages {.pure.} = enum
    PutStr = "Notcurses.putStr failed!"
    Render = "Notcurses.render failed!"
    Stop   = "Notcurses.stop failed!"

  NotcursesInitOption = distinct culonglong

  NotcursesInitOptions {.pure.} = enum
    InhibitSetlocale  = NCOPTION_INHIBIT_SETLOCALE.NotcursesInitOption,
    NoClearBitmaps    = NCOPTION_NO_CLEAR_BITMAPS.NotcursesInitOption,
    NoWinchSighandler = NCOPTION_NO_WINCH_SIGHANDLER.NotcursesInitOption,
    NoQuitSighandlers = NCOPTION_NO_QUIT_SIGHANDLERS.NotcursesInitOption,
    PreserveCursor    = NCOPTION_PRESERVE_CURSOR.NotcursesInitOption,
    SuppressBanners   = NCOPTION_SUPPRESS_BANNERS.NotcursesInitOption,
    NoAlternateScreen = NCOPTION_NO_ALTERNATE_SCREEN.NotcursesInitOption,
    NoFontChanges     = NCOPTION_NO_FONT_CHANGES.NotcursesInitOption,
    DrainInput        = NCOPTION_DRAIN_INPUT.NotcursesInitOption

  NotcursesInputEvent = distinct cint

  NotcursesInputEvents {.pure.} = enum
    Unknown = NCTYPES.NCTYPE_UNKNOWN.NotcursesInputEvent,
    Press   = NCTYPES.NCTYPE_PRESS.NotcursesInputEvent,
    Repeat  = NCTYPES.NCTYPE_REPEAT.NotcursesInputEvent,
    Release = NCTYPES.NCTYPE_RELEASE.NotcursesInputEvent

  NotcursesKey = distinct uint32

  NotcursesKeys {.pure.} = enum
    Tab         = NCKEY_TAB.NotcursesKey

    Esc         = NCKEY_ESC.NotcursesKey

    Space       = NCKEY_SPACE.NotcursesKey

    Invalid     = NCKEY_INVALID.NotcursesKey
    Resize      = NCKEY_RESIZE.NotcursesKey
    Up          = NCKEY_UP.NotcursesKey
    Right       = NCKEY_RIGHT.NotcursesKey
    Down        = NCKEY_DOWN.NotcursesKey
    Left        = NCKEY_LEFT.NotcursesKey
    Ins         = NCKEY_INS.NotcursesKey
    Del         = NCKEY_DEL.NotcursesKey
    Backspace   = NCKEY_BACKSPACE.NotcursesKey
    PgDown      = NCKEY_PGDOWN.NotcursesKey
    PgUp        = NCKEY_PGUP.NotcursesKey
    Home        = NCKEY_HOME.NotcursesKey
    End         = NCKEY_END.NotcursesKey
    F00         = NCKEY_F00.NotcursesKey
    F01         = NCKEY_F01.NotcursesKey
    F02         = NCKEY_F02.NotcursesKey
    F03         = NCKEY_F03.NotcursesKey
    F04         = NCKEY_F04.NotcursesKey
    F05         = NCKEY_F05.NotcursesKey
    F06         = NCKEY_F06.NotcursesKey
    F07         = NCKEY_F07.NotcursesKey
    F08         = NCKEY_F08.NotcursesKey
    F09         = NCKEY_F09.NotcursesKey
    F10         = NCKEY_F10.NotcursesKey
    F11         = NCKEY_F11.NotcursesKey
    F12         = NCKEY_F12.NotcursesKey
    F13         = NCKEY_F13.NotcursesKey
    F14         = NCKEY_F14.NotcursesKey
    F15         = NCKEY_F15.NotcursesKey
    F16         = NCKEY_F16.NotcursesKey
    F17         = NCKEY_F17.NotcursesKey
    F18         = NCKEY_F18.NotcursesKey
    F19         = NCKEY_F19.NotcursesKey
    F20         = NCKEY_F20.NotcursesKey
    F21         = NCKEY_F21.NotcursesKey
    F22         = NCKEY_F22.NotcursesKey
    F23         = NCKEY_F23.NotcursesKey
    F24         = NCKEY_F24.NotcursesKey
    F25         = NCKEY_F25.NotcursesKey
    F26         = NCKEY_F26.NotcursesKey
    F27         = NCKEY_F27.NotcursesKey
    F28         = NCKEY_F28.NotcursesKey
    F29         = NCKEY_F29.NotcursesKey
    F30         = NCKEY_F30.NotcursesKey
    F31         = NCKEY_F31.NotcursesKey
    F32         = NCKEY_F32.NotcursesKey
    F33         = NCKEY_F33.NotcursesKey
    F34         = NCKEY_F34.NotcursesKey
    F35         = NCKEY_F35.NotcursesKey
    F36         = NCKEY_F36.NotcursesKey
    F37         = NCKEY_F37.NotcursesKey
    F38         = NCKEY_F38.NotcursesKey
    F39         = NCKEY_F39.NotcursesKey
    F40         = NCKEY_F40.NotcursesKey
    F41         = NCKEY_F41.NotcursesKey
    F42         = NCKEY_F42.NotcursesKey
    F43         = NCKEY_F43.NotcursesKey
    F44         = NCKEY_F44.NotcursesKey
    F45         = NCKEY_F45.NotcursesKey
    F46         = NCKEY_F46.NotcursesKey
    F47         = NCKEY_F47.NotcursesKey
    F48         = NCKEY_F48.NotcursesKey
    F49         = NCKEY_F49.NotcursesKey
    F50         = NCKEY_F50.NotcursesKey
    F51         = NCKEY_F51.NotcursesKey
    F52         = NCKEY_F52.NotcursesKey
    F53         = NCKEY_F53.NotcursesKey
    F54         = NCKEY_F54.NotcursesKey
    F55         = NCKEY_F55.NotcursesKey
    F56         = NCKEY_F56.NotcursesKey
    F57         = NCKEY_F57.NotcursesKey
    F58         = NCKEY_F58.NotcursesKey
    F59         = NCKEY_F59.NotcursesKey
    F60         = NCKEY_F60.NotcursesKey

    Enter       = NCKEY_ENTER.NotcursesKey
    Cls         = NCKEY_CLS.NotcursesKey
    DLeft       = NCKEY_DLEFT.NotcursesKey
    DRight      = NCKEY_DRIGHT.NotcursesKey
    ULeft       = NCKEY_ULEFT.NotcursesKey
    URight      = NCKEY_URIGHT.NotcursesKey
    Center      = NCKEY_CENTER.NotcursesKey
    Begin       = NCKEY_BEGIN.NotcursesKey
    Cancel      = NCKEY_CANCEL.NotcursesKey
    Close       = NCKEY_CLOSE.NotcursesKey
    Command     = NCKEY_COMMAND.NotcursesKey
    Copy        = NCKEY_COPY.NotcursesKey
    Exit        = NCKEY_EXIT.NotcursesKey
    Print       = NCKEY_PRINT.NotcursesKey
    Refresh     = NCKEY_REFRESH.NotcursesKey
    Separator   = NCKEY_SEPARATOR.NotcursesKey

    CapsLock    = NCKEY_CAPS_LOCK.NotcursesKey
    ScrollLock  = NCKEY_SCROLL_LOCK.NotcursesKey
    NumLock     = NCKEY_NUM_LOCK.NotcursesKey
    PrintScreen = NCKEY_PRINT_SCREEN.NotcursesKey
    Pause       = NCKEY_PAUSE.NotcursesKey
    Menu        = NCKEY_MENU.NotcursesKey
    MediaPlay   = NCKEY_MEDIA_PLAY.NotcursesKey
    MediaPause  = NCKEY_MEDIA_PAUSE.NotcursesKey
    MediaPPause = NCKEY_MEDIA_PPAUSE.NotcursesKey
    MediaRev    = NCKEY_MEDIA_REV.NotcursesKey
    MediaStop   = NCKEY_MEDIA_STOP.NotcursesKey
    MediaFF     = NCKEY_MEDIA_FF.NotcursesKey
    MediaRewind = NCKEY_MEDIA_REWIND.NotcursesKey
    MediaNext   = NCKEY_MEDIA_NEXT.NotcursesKey
    MediaPrev   = NCKEY_MEDIA_PREV.NotcursesKey
    MediaRecord = NCKEY_MEDIA_RECORD.NotcursesKey
    MediaLVol   = NCKEY_MEDIA_LVOL.NotcursesKey
    MediaRVol   = NCKEY_MEDIA_RVOL.NotcursesKey
    MediaMute   = NCKEY_MEDIA_MUTE.NotcursesKey
    LShift      = NCKEY_LSHIFT.NotcursesKey
    LCtrl       = NCKEY_LCTRL.NotcursesKey
    LAlt        = NCKEY_LALT.NotcursesKey
    LSuper      = NCKEY_LSUPER.NotcursesKey
    LHyper      = NCKEY_LHYPER.NotcursesKey
    LMeta       = NCKEY_LMETA.NotcursesKey
    RShift      = NCKEY_RSHIFT.NotcursesKey
    RCtrl       = NCKEY_RCTRL.NotcursesKey
    RAlt        = NCKEY_RALT.NotcursesKey
    RSuper      = NCKEY_RSUPER.NotcursesKey
    RHyper      = NCKEY_RHYPER.NotcursesKey
    RMeta       = NCKEY_RMETA.NotcursesKey
    L3Shift     = NCKEY_L3SHIFT.NotcursesKey
    L5Shift     = NCKEY_L5SHIFT.NotcursesKey

    Motion      = NCKEY_MOTION.NotcursesKey
    Button1     = NCKEY_BUTTON1.NotcursesKey
    Button2     = NCKEY_BUTTON2.NotcursesKey
    Button3     = NCKEY_BUTTON3.NotcursesKey
    Button4     = NCKEY_BUTTON4.NotcursesKey
    Button5     = NCKEY_BUTTON5.NotcursesKey
    Button6     = NCKEY_BUTTON6.NotcursesKey
    Button7     = NCKEY_BUTTON7.NotcursesKey
    Button8     = NCKEY_BUTTON8.NotcursesKey
    Button9     = NCKEY_BUTTON9.NotcursesKey
    Button10    = NCKEY_BUTTON10.NotcursesKey
    Button11    = NCKEY_BUTTON11.NotcursesKey

    Signal      = NCKEY_SIGNAL.NotcursesKey

    EOF         = NCKEY_EOF.NotcursesKey
