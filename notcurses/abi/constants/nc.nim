# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include

# this module uses extra whitespace so it can be visually scanned more easily

type
  # L76 - notcurses/notcurses.h
  ncblitter_e* {.pure.} = enum
    NCBLIT_DEFAULT
    NCBLIT_1x1
    NCBLIT_2x1
    NCBLIT_2x2
    NCBLIT_3x2
    NCBLIT_BRAILLE
    NCBLIT_PIXEL
    NCBLIT_4x1
    NCBLIT_8x1

  # L84 - notcurses/notcurses.h
  ncalign_e* {.pure.} = enum
    NCALIGN_UNALIGNED
    NCALIGN_LEFT
    NCALIGN_CENTER
    NCALIGN_RIGHT

  # L101 - notcurses/notcurses.h
  ncscale_e* {.pure.} = enum
    NCSCALE_NONE
    NCSCALE_SCALE
    NCSCALE_STRETCH
    NCSCALE_NONE_HIRES
    NCSCALE_SCALE_HIRES

const
  # L104 - notcurses/notcurses.h
  NCALPHA_HIGHCONTRAST* = 0x0000000030000000'u64
  NCALPHA_TRANSPARENT*  = 0x0000000020000000'u64
  NCALPHA_BLEND*        = 0x0000000010000000'u64
  NCALPHA_OPAQUE*       = 0x0000000000000000'u64

  # L110 - notcurses/notcurses.h
  NCPALETTESIZE* = 256'i32

  # L115 - notcurses/notcurses.h
  NC_NOBACKGROUND_MASK* = 0x8700000000000000'u64
  NC_BGDEFAULT_MASK*    = 0x0000000040000000'u64
  NC_BG_RGB_MASK*       = 0x0000000000ffffff'u64
  NC_BG_PALETTE*        = 0x0000000008000000'u64
  NC_BG_ALPHA_MASK*     = 0x0000000030000000'u64

  # L594 - notcurses/notcurses.h
  WCHAR_MAX_UTF8BYTES* = 4'i32

# L978 - notcurses/notcurses.h
type ncloglevel_e* {.pure.} = enum
  NCLOGLEVEL_SILENT  = -1'i32
  NCLOGLEVEL_PANIC   =  0'i32
  NCLOGLEVEL_FATAL   =  1'i32
  NCLOGLEVEL_ERROR   =  2'i32
  NCLOGLEVEL_WARNING =  3'i32
  NCLOGLEVEL_INFO    =  4'i32
  NCLOGLEVEL_VERBOSE =  5'i32
  NCLOGLEVEL_DEBUG   =  6'i32
  NCLOGLEVEL_TRACE   =  7'i32

const
  # L990 - notcurses/notcurses.h
  NCOPTION_INHIBIT_SETLOCALE*   = 0x0000000000000001'u64
  NCOPTION_NO_CLEAR_BITMAPS*    = 0x0000000000000002'u64
  NCOPTION_NO_WINCH_SIGHANDLER* = 0x0000000000000004'u64
  NCOPTION_NO_QUIT_SIGHANDLERS* = 0x0000000000000008'u64
  NCOPTION_PRESERVE_CURSOR*     = 0x0000000000000010'u64
  NCOPTION_SUPPRESS_BANNERS*    = 0x0000000000000020'u64
  NCOPTION_NO_ALTERNATE_SCREEN* = 0x0000000000000040'u64
  NCOPTION_NO_FONT_CHANGES*     = 0x0000000000000080'u64
  NCOPTION_DRAIN_INPUT*         = 0x0000000000000100'u64
  NCOPTION_SCROLLING*           = 0x0000000000000200'u64
  NCOPTION_CLI_MODE*            = NCOPTION_NO_ALTERNATE_SCREEN or
                                  NCOPTION_NO_CLEAR_BITMAPS or
                                  NCOPTION_PRESERVE_CURSOR or
                                  NCOPTION_SCROLLING

# L1199 - notcurses/notcurses.h
type ncintype_e* {.pure.} = enum
  NCTYPE_UNKNOWN
  NCTYPE_PRESS
  NCTYPE_REPEAT
  NCTYPE_RELEASE

const
  # L1332 - notcurses/notcurses.h
  NCMICE_NO_EVENTS*    = 0x00000000'u32
  NCMICE_MOVE_EVENT*   = 0x00000001'u32
  NCMICE_BUTTON_EVENT* = 0x00000002'u32
  NCMICE_DRAG_EVENT*   = 0x00000004'u32
  NCMICE_ALL_EVENTS*   = 0x00000007'u32

# L1687 - notcurses/notcurses.h
type ncpixelimpl_e* {.pure.} = enum
  NCPIXEL_NONE
  NCPIXEL_SIXEL
  NCPIXEL_LINUXFB
  NCPIXEL_ITERM2
  NCPIXEL_KITTY_STATIC
  NCPIXEL_KITTY_ANIMATED
  NCPIXEL_KITTY_SELFREF
