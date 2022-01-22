import std/bitops

const PRETERUNICODEBASE = 1115000.uint32

proc preterunicode(w: uint32): uint32 = w + PRETERUNICODEBASE

const
  NCKEY_TAB          = 9.uint32

  NCKEY_ESC          = 27.uint32

  NCKEY_SPACE        = 32.uint32

  NCKEY_INVALID      = preterunicode 0.uint32
  NCKEY_RESIZE       = preterunicode 1.uint32
  NCKEY_UP           = preterunicode 2.uint32
  NCKEY_RIGHT        = preterunicode 3.uint32
  NCKEY_DOWN         = preterunicode 4.uint32
  NCKEY_LEFT         = preterunicode 5.uint32
  NCKEY_INS          = preterunicode 6.uint32
  NCKEY_DEL          = preterunicode 7.uint32
  NCKEY_BACKSPACE    = preterunicode 8.uint32
  NCKEY_PGDOWN       = preterunicode 9.uint32
  NCKEY_PGUP         = preterunicode 10.uint32
  NCKEY_HOME         = preterunicode 11.uint32
  NCKEY_END          = preterunicode 12.uint32
  NCKEY_F00          = preterunicode 20.uint32
  NCKEY_F01          = preterunicode 21.uint32
  NCKEY_F02          = preterunicode 22.uint32
  NCKEY_F03          = preterunicode 23.uint32
  NCKEY_F04          = preterunicode 24.uint32
  NCKEY_F05          = preterunicode 25.uint32
  NCKEY_F06          = preterunicode 26.uint32
  NCKEY_F07          = preterunicode 27.uint32
  NCKEY_F08          = preterunicode 28.uint32
  NCKEY_F09          = preterunicode 29.uint32
  NCKEY_F10          = preterunicode 30.uint32
  NCKEY_F11          = preterunicode 31.uint32
  NCKEY_F12          = preterunicode 32.uint32
  NCKEY_F13          = preterunicode 33.uint32
  NCKEY_F14          = preterunicode 34.uint32
  NCKEY_F15          = preterunicode 35.uint32
  NCKEY_F16          = preterunicode 36.uint32
  NCKEY_F17          = preterunicode 37.uint32
  NCKEY_F18          = preterunicode 38.uint32
  NCKEY_F19          = preterunicode 39.uint32
  NCKEY_F20          = preterunicode 40.uint32
  NCKEY_F21          = preterunicode 41.uint32
  NCKEY_F22          = preterunicode 42.uint32
  NCKEY_F23          = preterunicode 43.uint32
  NCKEY_F24          = preterunicode 44.uint32
  NCKEY_F25          = preterunicode 45.uint32
  NCKEY_F26          = preterunicode 46.uint32
  NCKEY_F27          = preterunicode 47.uint32
  NCKEY_F28          = preterunicode 48.uint32
  NCKEY_F29          = preterunicode 49.uint32
  NCKEY_F30          = preterunicode 50.uint32
  NCKEY_F31          = preterunicode 51.uint32
  NCKEY_F32          = preterunicode 52.uint32
  NCKEY_F33          = preterunicode 53.uint32
  NCKEY_F34          = preterunicode 54.uint32
  NCKEY_F35          = preterunicode 55.uint32
  NCKEY_F36          = preterunicode 56.uint32
  NCKEY_F37          = preterunicode 57.uint32
  NCKEY_F38          = preterunicode 58.uint32
  NCKEY_F39          = preterunicode 59.uint32
  NCKEY_F40          = preterunicode 60.uint32
  NCKEY_F41          = preterunicode 61.uint32
  NCKEY_F42          = preterunicode 62.uint32
  NCKEY_F43          = preterunicode 63.uint32
  NCKEY_F44          = preterunicode 64.uint32
  NCKEY_F45          = preterunicode 65.uint32
  NCKEY_F46          = preterunicode 66.uint32
  NCKEY_F47          = preterunicode 67.uint32
  NCKEY_F48          = preterunicode 68.uint32
  NCKEY_F49          = preterunicode 69.uint32
  NCKEY_F50          = preterunicode 70.uint32
  NCKEY_F51          = preterunicode 71.uint32
  NCKEY_F52          = preterunicode 72.uint32
  NCKEY_F53          = preterunicode 73.uint32
  NCKEY_F54          = preterunicode 74.uint32
  NCKEY_F55          = preterunicode 75.uint32
  NCKEY_F56          = preterunicode 76.uint32
  NCKEY_F57          = preterunicode 77.uint32
  NCKEY_F58          = preterunicode 78.uint32
  NCKEY_F59          = preterunicode 79.uint32
  NCKEY_F60          = preterunicode 80.uint32

  NCKEY_ENTER        = preterunicode 121.uint32
  NCKEY_CLS          = preterunicode 122.uint32
  NCKEY_DLEFT        = preterunicode 123.uint32
  NCKEY_DRIGHT       = preterunicode 124.uint32
  NCKEY_ULEFT        = preterunicode 125.uint32
  NCKEY_URIGHT       = preterunicode 126.uint32
  NCKEY_CENTER       = preterunicode 127.uint32
  NCKEY_BEGIN        = preterunicode 128.uint32
  NCKEY_CANCEL       = preterunicode 129.uint32
  NCKEY_CLOSE        = preterunicode 130.uint32
  NCKEY_COMMAND      = preterunicode 131.uint32
  NCKEY_COPY         = preterunicode 132.uint32
  NCKEY_EXIT         = preterunicode 133.uint32
  NCKEY_PRINT        = preterunicode 134.uint32
  NCKEY_REFRESH      = preterunicode 135.uint32
  NCKEY_SEPARATOR    = preterunicode 136.uint32

  NCKEY_CAPS_LOCK    = preterunicode 150.uint32
  NCKEY_SCROLL_LOCK  = preterunicode 151.uint32
  NCKEY_NUM_LOCK     = preterunicode 152.uint32
  NCKEY_PRINT_SCREEN = preterunicode 153.uint32
  NCKEY_PAUSE        = preterunicode 154.uint32
  NCKEY_MENU         = preterunicode 155.uint32
  NCKEY_MEDIA_PLAY   = preterunicode 158.uint32
  NCKEY_MEDIA_PAUSE  = preterunicode 159.uint32
  NCKEY_MEDIA_PPAUSE = preterunicode 160.uint32
  NCKEY_MEDIA_REV    = preterunicode 161.uint32
  NCKEY_MEDIA_STOP   = preterunicode 162.uint32
  NCKEY_MEDIA_FF     = preterunicode 163.uint32
  NCKEY_MEDIA_REWIND = preterunicode 164.uint32
  NCKEY_MEDIA_NEXT   = preterunicode 165.uint32
  NCKEY_MEDIA_PREV   = preterunicode 166.uint32
  NCKEY_MEDIA_RECORD = preterunicode 167.uint32
  NCKEY_MEDIA_LVOL   = preterunicode 168.uint32
  NCKEY_MEDIA_RVOL   = preterunicode 169.uint32
  NCKEY_MEDIA_MUTE   = preterunicode 170.uint32
  NCKEY_LSHIFT       = preterunicode 171.uint32
  NCKEY_LCTRL        = preterunicode 172.uint32
  NCKEY_LALT         = preterunicode 173.uint32
  NCKEY_LSUPER       = preterunicode 174.uint32
  NCKEY_LHYPER       = preterunicode 175.uint32
  NCKEY_LMETA        = preterunicode 176.uint32
  NCKEY_RSHIFT       = preterunicode 177.uint32
  NCKEY_RCTRL        = preterunicode 178.uint32
  NCKEY_RALT         = preterunicode 179.uint32
  NCKEY_RSUPER       = preterunicode 180.uint32
  NCKEY_RHYPER       = preterunicode 181.uint32
  NCKEY_RMETA        = preterunicode 182.uint32
  NCKEY_L3SHIFT      = preterunicode 183.uint32
  NCKEY_L5SHIFT      = preterunicode 184.uint32

  NCKEY_MOTION       = preterunicode 200.uint32
  NCKEY_BUTTON1      = preterunicode 201.uint32
  NCKEY_BUTTON2      = preterunicode 202.uint32
  NCKEY_BUTTON3      = preterunicode 203.uint32
  NCKEY_BUTTON4      = preterunicode 204.uint32
  NCKEY_BUTTON5      = preterunicode 205.uint32
  NCKEY_BUTTON6      = preterunicode 206.uint32
  NCKEY_BUTTON7      = preterunicode 207.uint32
  NCKEY_BUTTON8      = preterunicode 208.uint32
  NCKEY_BUTTON9      = preterunicode 209.uint32
  NCKEY_BUTTON10     = preterunicode 210.uint32
  NCKEY_BUTTON11     = preterunicode 211.uint32

  NCKEY_SIGNAL       = preterunicode 400.uint32

  NCKEY_EOF          = preterunicode 500.uint32

  NCKEY_RETURN       = NCKEY_ENTER
  NCKEY_SCROLL_UP    = NCKEY_BUTTON4
  NCKEY_SCROLL_DOWN  = NCKEY_BUTTON5

const
  NCOPTION_INHIBIT_SETLOCALE   = 0x0000000000000001.culonglong
  NCOPTION_NO_CLEAR_BITMAPS    = 0x0000000000000002.culonglong
  NCOPTION_NO_WINCH_SIGHANDLER = 0x0000000000000004.culonglong
  NCOPTION_NO_QUIT_SIGHANDLERS = 0x0000000000000008.culonglong
  NCOPTION_PRESERVE_CURSOR     = 0x0000000000000010.culonglong
  NCOPTION_SUPPRESS_BANNERS    = 0x0000000000000020.culonglong
  NCOPTION_NO_ALTERNATE_SCREEN = 0x0000000000000040.culonglong
  NCOPTION_NO_FONT_CHANGES     = 0x0000000000000080.culonglong
  NCOPTION_DRAIN_INPUT         = 0x0000000000000100.culonglong
  NCOPTION_SCROLLING           = 0x0000000000000200.culonglong

  NCOPTION_CLI_MODE            =
    when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
      bitor(NCOPTION_NO_ALTERNATE_SCREEN, NCOPTION_NO_CLEAR_BITMAPS,
        NCOPTION_PRESERVE_CURSOR, NCOPTION_SCROLLING)
    else:
      bitor(bitor(bitor(NCOPTION_NO_ALTERNATE_SCREEN,
        NCOPTION_NO_CLEAR_BITMAPS), NCOPTION_PRESERVE_CURSOR),
        NCOPTION_SCROLLING)

type
  NCTYPE {.pure.} = enum
    NCTYPE_UNKNOWN = 0.cint
    NCTYPE_PRESS   = 1.cint
    NCTYPE_REPEAT  = 2.cint
    NCTYPE_RELEASE = 3.cint

  ncloglevel_e {.pure.} = enum
    NCLOGLEVEL_SILENT = -1.cint
    NCLOGLEVEL_PANIC = 0.cint
    NCLOGLEVEL_FATAL = 1.cint
    NCLOGLEVEL_ERROR = 2.cint
    NCLOGLEVEL_WARNING = 3.cint
    NCLOGLEVEL_INFO = 4.cint
    NCLOGLEVEL_VERBOSE = 5.cint
    NCLOGLEVEL_DEBUG = 6.cint
    NCLOGLEVEL_TRACE = 7.cint
