# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include

# this module uses extra whitespace so it can be visually scanned more easily

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[bitops, macros, posix, strutils, terminal, typetraits]
import pkg/stew/endians2

export Time, Timespec, toLE

type AbiDefect = object of Defect

const
  wchar_header = "<wchar.h>"
  wchar_t = "wchar_t"

# wchar_t is implementation-defined so use of that type as specified below may
# produce incorrect results on some platforms
when defined(windows):
  # https://learn.microsoft.com/en-us/windows/win32/midl/wchar-t
  type Wchar* {.header: wchar_header, importc: wchar_t.} = distinct uint16
else:
  type Wchar* {.header: wchar_header, importc: wchar_t.} = distinct uint32

template wchar*(u: untyped): Wchar = u.Wchar

proc wcwidth*(wc: Wchar): cint {.cdecl, header: wchar_header, importc.}

const nc_keys_header = "notcurses/nckeys.h"
{.pragma: nc_keys, cdecl, header: nc_keys_header, importc.}

# L31 - notcurses/nckeys.h
const PRETERUNICODEBASE* = 1115000'u32

# L32 - notcurses/nckeys.h
func preterunicode*(w: uint32): uint32 = w + PRETERUNICODEBASE

const
  # L195 - notcurses/nckeys.h
  NCKEY_TAB*          = 9'u32

  NCKEY_ESC*          = 27'u32

  NCKEY_SPACE*        = 32'u32

  # L35 - notcurses/nckeys.h
  NCKEY_INVALID*      = preterunicode 0'u32
  NCKEY_RESIZE*       = preterunicode 1'u32
  NCKEY_UP*           = preterunicode 2'u32
  NCKEY_RIGHT*        = preterunicode 3'u32
  NCKEY_DOWN*         = preterunicode 4'u32
  NCKEY_LEFT*         = preterunicode 5'u32
  NCKEY_INS*          = preterunicode 6'u32
  NCKEY_DEL*          = preterunicode 7'u32
  NCKEY_BACKSPACE*    = preterunicode 8'u32
  NCKEY_PGDOWN*       = preterunicode 9'u32
  NCKEY_PGUP*         = preterunicode 10'u32
  NCKEY_HOME*         = preterunicode 11'u32
  NCKEY_END*          = preterunicode 12'u32
  NCKEY_F00*          = preterunicode 20'u32
  NCKEY_F01*          = preterunicode 21'u32
  NCKEY_F02*          = preterunicode 22'u32
  NCKEY_F03*          = preterunicode 23'u32
  NCKEY_F04*          = preterunicode 24'u32
  NCKEY_F05*          = preterunicode 25'u32
  NCKEY_F06*          = preterunicode 26'u32
  NCKEY_F07*          = preterunicode 27'u32
  NCKEY_F08*          = preterunicode 28'u32
  NCKEY_F09*          = preterunicode 29'u32
  NCKEY_F10*          = preterunicode 30'u32
  NCKEY_F11*          = preterunicode 31'u32
  NCKEY_F12*          = preterunicode 32'u32
  NCKEY_F13*          = preterunicode 33'u32
  NCKEY_F14*          = preterunicode 34'u32
  NCKEY_F15*          = preterunicode 35'u32
  NCKEY_F16*          = preterunicode 36'u32
  NCKEY_F17*          = preterunicode 37'u32
  NCKEY_F18*          = preterunicode 38'u32
  NCKEY_F19*          = preterunicode 39'u32
  NCKEY_F20*          = preterunicode 40'u32
  NCKEY_F21*          = preterunicode 41'u32
  NCKEY_F22*          = preterunicode 42'u32
  NCKEY_F23*          = preterunicode 43'u32
  NCKEY_F24*          = preterunicode 44'u32
  NCKEY_F25*          = preterunicode 45'u32
  NCKEY_F26*          = preterunicode 46'u32
  NCKEY_F27*          = preterunicode 47'u32
  NCKEY_F28*          = preterunicode 48'u32
  NCKEY_F29*          = preterunicode 49'u32
  NCKEY_F30*          = preterunicode 50'u32
  NCKEY_F31*          = preterunicode 51'u32
  NCKEY_F32*          = preterunicode 52'u32
  NCKEY_F33*          = preterunicode 53'u32
  NCKEY_F34*          = preterunicode 54'u32
  NCKEY_F35*          = preterunicode 55'u32
  NCKEY_F36*          = preterunicode 56'u32
  NCKEY_F37*          = preterunicode 57'u32
  NCKEY_F38*          = preterunicode 58'u32
  NCKEY_F39*          = preterunicode 59'u32
  NCKEY_F40*          = preterunicode 60'u32
  NCKEY_F41*          = preterunicode 61'u32
  NCKEY_F42*          = preterunicode 62'u32
  NCKEY_F43*          = preterunicode 63'u32
  NCKEY_F44*          = preterunicode 64'u32
  NCKEY_F45*          = preterunicode 65'u32
  NCKEY_F46*          = preterunicode 66'u32
  NCKEY_F47*          = preterunicode 67'u32
  NCKEY_F48*          = preterunicode 68'u32
  NCKEY_F49*          = preterunicode 69'u32
  NCKEY_F50*          = preterunicode 70'u32
  NCKEY_F51*          = preterunicode 71'u32
  NCKEY_F52*          = preterunicode 72'u32
  NCKEY_F53*          = preterunicode 73'u32
  NCKEY_F54*          = preterunicode 74'u32
  NCKEY_F55*          = preterunicode 75'u32
  NCKEY_F56*          = preterunicode 76'u32
  NCKEY_F57*          = preterunicode 77'u32
  NCKEY_F58*          = preterunicode 78'u32
  NCKEY_F59*          = preterunicode 79'u32
  NCKEY_F60*          = preterunicode 80'u32

  # L110 - notcurses/nckeys.h
  NCKEY_ENTER*        = preterunicode 121'u32
  NCKEY_CLS*          = preterunicode 122'u32
  NCKEY_DLEFT*        = preterunicode 123'u32
  NCKEY_DRIGHT*       = preterunicode 124'u32
  NCKEY_ULEFT*        = preterunicode 125'u32
  NCKEY_URIGHT*       = preterunicode 126'u32
  NCKEY_CENTER*       = preterunicode 127'u32
  NCKEY_BEGIN*        = preterunicode 128'u32
  NCKEY_CANCEL*       = preterunicode 129'u32
  NCKEY_CLOSE*        = preterunicode 130'u32
  NCKEY_COMMAND*      = preterunicode 131'u32
  NCKEY_COPY*         = preterunicode 132'u32
  NCKEY_EXIT*         = preterunicode 133'u32
  NCKEY_PRINT*        = preterunicode 134'u32
  NCKEY_REFRESH*      = preterunicode 135'u32
  NCKEY_SEPARATOR*    = preterunicode 136'u32

  # L127 - notcurses/nckeys.h
  NCKEY_CAPS_LOCK*    = preterunicode 150'u32
  NCKEY_SCROLL_LOCK*  = preterunicode 151'u32
  NCKEY_NUM_LOCK*     = preterunicode 152'u32
  NCKEY_PRINT_SCREEN* = preterunicode 153'u32
  NCKEY_PAUSE*        = preterunicode 154'u32
  NCKEY_MENU*         = preterunicode 155'u32

  # L134 - notcurses/nckeys.h
  NCKEY_MEDIA_PLAY*   = preterunicode 158'u32
  NCKEY_MEDIA_PAUSE*  = preterunicode 159'u32
  NCKEY_MEDIA_PPAUSE* = preterunicode 160'u32
  NCKEY_MEDIA_REV*    = preterunicode 161'u32
  NCKEY_MEDIA_STOP*   = preterunicode 162'u32
  NCKEY_MEDIA_FF*     = preterunicode 163'u32
  NCKEY_MEDIA_REWIND* = preterunicode 164'u32
  NCKEY_MEDIA_NEXT*   = preterunicode 165'u32
  NCKEY_MEDIA_PREV*   = preterunicode 166'u32
  NCKEY_MEDIA_RECORD* = preterunicode 167'u32
  NCKEY_MEDIA_LVOL*   = preterunicode 168'u32
  NCKEY_MEDIA_RVOL*   = preterunicode 169'u32
  NCKEY_MEDIA_MUTE*   = preterunicode 170'u32
  NCKEY_LSHIFT*       = preterunicode 171'u32
  NCKEY_LCTRL*        = preterunicode 172'u32
  NCKEY_LALT*         = preterunicode 173'u32
  NCKEY_LSUPER*       = preterunicode 174'u32
  NCKEY_LHYPER*       = preterunicode 175'u32
  NCKEY_LMETA*        = preterunicode 176'u32
  NCKEY_RSHIFT*       = preterunicode 177'u32
  NCKEY_RCTRL*        = preterunicode 178'u32
  NCKEY_RALT*         = preterunicode 179'u32
  NCKEY_RSUPER*       = preterunicode 180'u32
  NCKEY_RHYPER*       = preterunicode 181'u32
  NCKEY_RMETA*        = preterunicode 182'u32
  NCKEY_L3SHIFT*      = preterunicode 183'u32
  NCKEY_L5SHIFT*      = preterunicode 184'u32

  # L165 - notcurses/nckeys.h
  NCKEY_MOTION*       = preterunicode 200'u32
  NCKEY_BUTTON1*      = preterunicode 201'u32
  NCKEY_BUTTON2*      = preterunicode 202'u32
  NCKEY_BUTTON3*      = preterunicode 203'u32
  NCKEY_BUTTON4*      = preterunicode 204'u32
  NCKEY_BUTTON5*      = preterunicode 205'u32
  NCKEY_BUTTON6*      = preterunicode 206'u32
  NCKEY_BUTTON7*      = preterunicode 207'u32
  NCKEY_BUTTON8*      = preterunicode 208'u32
  NCKEY_BUTTON9*      = preterunicode 209'u32
  NCKEY_BUTTON10*     = preterunicode 210'u32
  NCKEY_BUTTON11*     = preterunicode 211'u32

  # L179 - notcurses/nckeys.h
  NCKEY_SIGNAL*       = preterunicode 400'u32

  # L183 - notcurses/nckeys.h
  NCKEY_EOF*          = preterunicode 500'u32

  # L192 - notcurses/nckeys.h
  NCKEY_SCROLL_UP*    = NCKEY_BUTTON4
  NCKEY_SCROLL_DOWN*  = NCKEY_BUTTON5
  NCKEY_RETURN*       = NCKEY_ENTER

  # L219 - notcurses/nckeys.h
  NCKEY_MOD_SHIFT*    =   1'i32
  NCKEY_MOD_ALT*      =   2'i32
  NCKEY_MOD_CTRL*     =   4'i32
  NCKEY_MOD_SUPER*    =   8'i32
  NCKEY_MOD_HYPER*    =  16'i32
  NCKEY_MOD_META*     =  32'i32
  NCKEY_MOD_CAPSLOCK* =  64'i32
  NCKEY_MOD_NUMLOCK*  = 128'i32

const nc_header = "notcurses/notcurses.h"
{.pragma: nc, cdecl, header: nc_header, importc.}
{.pragma: nc_bycopy, bycopy, header: nc_header.}
{.pragma: nc_incomplete, header: nc_header, incompleteStruct.}

type
  # L44 - notcurses/notcurses.h
  notcurses*       {.nc_incomplete, importc: "struct notcurses"      .} = object
  ncplane*         {.nc_incomplete, importc: "struct ncplane"        .} = object
  ncvisual*        {.nc_incomplete, importc: "struct ncvisual"       .} = object
  ncuplot*         {.nc_incomplete, importc: "struct ncuplot"        .} = object
  ncdplot*         {.nc_incomplete, importc: "struct ncdplot"        .} = object
  ncprogbar*       {.nc_incomplete, importc: "struct ncprogbar"      .} = object
  ncfdplane*       {.nc_incomplete, importc: "struct ncfdplane"      .} = object
  ncsubproc*       {.nc_incomplete, importc: "struct ncsubproc"      .} = object
  ncselector*      {.nc_incomplete, importc: "struct ncselector"     .} = object
  ncmultiselector* {.nc_incomplete, importc: "struct ncmultiselector".} = object
  ncreader*        {.nc_incomplete, importc: "struct ncreader"       .} = object
  ncfadectx*       {.nc_incomplete, importc: "struct ncfadectx"      .} = object
  nctablet*        {.nc_incomplete, importc: "struct nctablet"       .} = object
  ncreel*          {.nc_incomplete, importc: "struct ncreel"         .} = object
  nctab*           {.nc_incomplete, importc: "struct nctab"          .} = object
  nctabbed*        {.nc_incomplete, importc: "struct nctabbed"       .} = object
  ncdirect*        {.nc_incomplete, importc: "struct ncdirect"       .} = object

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

type
  # L724 - notcurses/notcurses.h
  nccell* {.nc_bycopy, importc: "struct nccell".} = object
    gcluster*         : uint32
    gcluster_backstop*: uint8
    width*            : uint8
    stylemask*        : uint16
    channels*         : uint64

# consider whether these should be uint16
const
  # L769 - notcurses/notcurses.h
  NCSTYLE_MASK*      = 0x0000ffff'u32
  NCSTYLE_ITALIC*    = 0x00000010'u32
  NCSTYLE_UNDERLINE* = 0x00000008'u32
  NCSTYLE_UNDERCURL* = 0x00000004'u32
  NCSTYLE_BOLD*      = 0x00000002'u32
  NCSTYLE_STRUCK*    = 0x00000001'u32
  NCSTYLE_NONE*      = 0x00000000'u32

type
  # L978 - notcurses/notcurses.h
  ncloglevel_e* {.pure.} = enum
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
  NCOPTION_CLI_MODE*            = NCOPTION_NO_ALTERNATE_SCREEN or NCOPTION_NO_CLEAR_BITMAPS or NCOPTION_PRESERVE_CURSOR or NCOPTION_SCROLLING

type
  # L1060 - notcurses/notcurses.h
  notcurses_options* {.nc_bycopy, importc: "struct notcurses_options".} = object
    termtype*: cstring
    loglevel*: ncloglevel_e
    margin_t*: uint32
    margin_r*: uint32
    margin_b*: uint32
    margin_l*: uint32
    flags*   : uint64

  # L1199 - notcurses/notcurses.h
  ncintype_e* {.pure.} = enum
    NCTYPE_UNKNOWN
    NCTYPE_PRESS
    NCTYPE_REPEAT
    NCTYPE_RELEASE

  # L1217 - notcurses/notcurses.h
  ncinput* {.nc_bycopy, importc: "struct ncinput".} = object
    id*       : uint32
    y*        : int32
    x*        : int32
    utf8*     : array[5, char]
    alt*      : bool
    shift*    : bool
    ctrl*     : bool
    evtype*   : ncintype_e
    modifiers*: uint32
    ypx*      : int32
    xpx*      : int32

const
  # L1332 - notcurses/notcurses.h
  NCMICE_NO_EVENTS*    = 0x00000000'u32
  NCMICE_MOVE_EVENT*   = 0x00000001'u32
  NCMICE_BUTTON_EVENT* = 0x00000002'u32
  NCMICE_DRAG_EVENT*   = 0x00000004'u32
  NCMICE_ALL_EVENTS*   = 0x00000007'u32

type
  # L1472 -  notcurses/notcurses.h
  ncplane_options* {.nc_bycopy, importc: "struct ncplane_options".} = object
    y*       : int32
    x*       : int32
    rows*    : uint32
    cols*    : uint32
    userptr* : pointer
    name*    : cstring
    resizecb*: proc (n: ptr ncplane): int32 {.noconv.}
    flags*   : uint64
    margin_b*: uint32
    margin_r*: uint32

  # L1584 -  notcurses/notcurses.h
  ncpalette* {.nc_bycopy, importc: "struct ncpalette".} = object
    chans*: array[NCPALETTESIZE, uint32]

  # L1644 - notcurses/notcurses.h
  nccapabilities* {.nc_bycopy, importc: "struct nccapabilities".} = object
    colors*           : cuint
    utf8*             : bool
    rgb*              : bool
    can_change_colors*: bool
    halfblocks*       : bool
    quadrants*        : bool
    sextants*         : bool
    braille*          : bool

  # L1687 - notcurses/notcurses.h
  ncpixelimpl_e* {.pure.} = enum
    NCPIXEL_NONE
    NCPIXEL_SIXEL
    NCPIXEL_LINUXFB
    NCPIXEL_ITERM2
    NCPIXEL_KITTY_STATIC
    NCPIXEL_KITTY_ANIMATED
    NCPIXEL_KITTY_SELFREF

  # L3324 - notcurses/notcurses.h
  ncvisual_options* {.nc_bycopy, importc: "struct ncvisual_options".} = object
    n*         : ptr ncplane
    scaling*   : ncscale_e
    y*         : int32
    x*         : int32
    begy*      : uint32
    begx*      : uint32
    leny*      : uint32
    lenx*      : uint32
    blitter*   : ncblitter_e
    flags*     : uint64
    transcolor*: uint32
    pxoffy*    : uint32
    pxoffx*    : uint32

  # L3946 - notcurses/notcurses.h
  ncmselector_item* {.nc_bycopy, importc: "struct ncmselector_item".} = object
    option*  : cstring
    desc*    : cstring
    selected*: bool

  # L3987 - notcurses/notcurses.h
  ncmultiselector_options* {.nc_bycopy, importc: "struct ncmultiselector_options".} = object
    title*        : cstring
    secondary*    : cstring
    footer*       : cstring
    items*        : ptr UncheckedArray[ncmselector_item]
    maxdisplay*   : uint32
    opchannels*   : uint64
    descchannels* : uint64
    titlechannels*: uint64
    footchannels* : uint64
    boxchannels*  : uint64
    flags*        : uint64

const ncd_header = "notcurses/direct.h"
{.pragma: ncd, cdecl, header: ncd_header, importc.}

const
  # L29 - notcurses/direct.h
  NCDIRECT_OPTION_INHIBIT_SETLOCALE*   = 0x0000000000000001'u64
  NCDIRECT_OPTION_INHIBIT_CBREAK*      = 0x0000000000000002'u64
  NCDIRECT_OPTION_DRAIN_INPUT*         = 0x0000000000000004'u64
  NCDIRECT_OPTION_NO_QUIT_SIGHANDLERS* = 0x0000000000000008'u64
  NCDIRECT_OPTION_VERBOSE*             = 0x0000000000000010'u64
  NCDIRECT_OPTION_VERY_VERBOSE*        = 0x0000000000000020'u64

# adapted from: https://stackoverflow.com/a/148766
# `func toSeqDbW` assumes encoding of multibyte string `s` is valid UTF-8, so
# it's suitable for helping define wide string literals in notcurses/ncseqs.h
# with const, but is not suitable as a general purpose utility
func toSeqDbW(s: string, l: int): seq[distinctBase(Wchar)] =
  var
    c = 0'u8
    codepoint: uint32
    i = 0
    codes: seq[distinctBase(Wchar)]
  while true:
    if i == l:
      codes.add 0
      break
    c = s[i].uint8
    if c <= 0x7f:
      codepoint = c
    elif c <= 0xbf:
      codepoint = bitor(codepoint shl 6, bitand(c, 0x3f))
    elif c <= 0xdf:
      codepoint = bitand(c, 0x1f)
    elif c <= 0xef:
      codepoint = bitand(c, 0x0f)
    else:
      codepoint = bitand(c, 0x07)
    inc i
    var ci: uint8
    if i == l:
      ci = 0
    else:
      ci = s[i].uint8
    if (bitand(ci, 0xc0) != 0x80) and (codepoint <= 0x10ffff):
      when sizeof(Wchar) > 2:
        codes.add codepoint
      else:
        if codepoint > 0xffff:
          codepoint = codepoint - 0x10000
          codes.add (0xd800 + (codepoint shr 10)).uint16
          codes.add (0xdc00 + bitand(codepoint, 0x03ff)).uint16
        elif (codepoint < 0xd800) or (codepoint >= 0xe000):
          codes.add codepoint.uint16
  codes

# https://en.cppreference.com/w/c/language/string_literal
macro L(s: static string): untyped =
  # debugEcho s
  result = newStmtList()
  let
    toArrayW = genSym(nskProc, "toArrayW")
    codes = toSeqDbW(s, s.len)
    l = codes.len
  result.add quote do:
    func `toArrayW`(): array[`l`, Wchar] =
      var a: array[`l`, Wchar]
      for i, codepoint in `codes`:
        a[i] = codepoint.wchar
      a
    `toArrayW`()
  # debugEcho toStrLit(result)

const
  # L9 - notcurses/ncseqs.h
  NCBOXLIGHTW*  = L"┌┐└┘─│"
  NCBOXHEAVYW*  = L"┏┓┗┛━┃"
  NCBOXROUNDW*  = L"╭╮╰╯─│"
  NCBOXDOUBLEW* = L"╔╗╚╝═║"
  NCBOXASCIIW*  = L("/\\\\/-|")
  NCBOXOUTERW*  = L"🭽🭾🭼🭿▁🭵🭶🭰"

  # L17 - notcurses/ncseqs.h
  NCWHITESQUARESW*   = L"◲◱◳◰"
  NCWHITECIRCLESW*   = L"◶◵◷◴"
  NCCIRCULARARCSW*   = L"◜◝◟◞"
  NCWHITETRIANGLESW* = L"◿◺◹◸"
  NCBLACKTRIANGLESW* = L"◢◣◥◤"
  NCSHADETRIANGLESW* = L"🮞🮟🮝🮜"

  # L25 - notcurses/ncseqs.h
  NCBLACKARROWHEADSW* = L"⮝⮟⮜⮞"
  NCLIGHTARROWHEADSW* = L"⮙⮛⮘⮚"
  NCARROWDOUBLEW*     = L"⮅⮇⮄⮆"
  NCARROWDASHEDW*     = L"⭫⭭⭪⭬"
  NCARROWCIRCLEDW*    = L"⮉⮋⮈⮊"
  NCARROWANTICLOCKW*  = L"⮏⮍⮎⮌"
  NCBOXDRAWW*         = L"╵╷╴╶"
  NCBOXDRAWHEAVYW*    = L"╹╻╸╺"

  # L35 - notcurses/ncseqs.h
  NCARROWW*     = L"⭡⭣⭠⭢⭧⭩⭦⭨"
  NCDIAGONALSW* = L"🮣🮠🮡🮢🮤🮥🮦🮧"

  # L39 - notcurses/ncseqs.h
  NCDIGITSSUPERW* = L"⁰¹²³⁴⁵⁶⁷⁸⁹"
  NCDIGITSSUBW*   = L"₀₁₂₃₄₅₆₇₈₉"

  # L43 - notcurses/ncseqs.h
  NCASTERISKS5* = L"🞯🞰🞱🞲🞳🞴"
  NCASTERISKS6* = L"🞵🞶🞷🞸🞹🞺"
  NCASTERISKS8* = L"🞻🞼✳🞽🞾🞿"

  # L48 - notcurses/ncseqs.h
  NCANGLESBR*   = L"🭁🭂🭃🭄🭅🭆🭇🭈🭉🭊🭋"
  NCANGLESTR*   = L"🭒🭓🭔🭕🭖🭧🭢🭣🭤🭥🭦"
  NCANGLESBL*   = L"🭌🭍🭎🭏🭐🭑🬼🬽🬾🬿🭀"
  NCANGLESTL*   = L"🭝🭞🭟🭠🭡🭜🭗🭘🭙🭚🭛"
  NCEIGHTHSB*   = L" ▁▂▃▄▅▆▇█"
  NCEIGHTHST*   = L" ▔🮂🮃▀🮄🮅🮆█"
  NCEIGHTHSL*   = L"▏▎▍▌▋▊▉█"
  NCEIGHTHSR*   = L"▕🮇🮈▐🮉🮊🮋█"
  NCHALFBLOCKS* = L" ▀▄█"
  NCQUADBLOCKS* = L" ▘▝▀▖▌▞▛▗▚▐▜▄▙▟█"
  NCSEXBLOCKS*  = L" 🬀🬁🬂🬃🬄🬅🬆🬇🬈🬊🬋🬌🬍🬎🬏🬐🬑🬒🬓▌🬔🬕🬖🬗🬘🬙🬚🬛🬜🬝🬞🬟🬠🬡🬢🬣🬤🬥🬦🬧▐🬨🬩🬪🬫🬬🬭🬮🬯🬰🬱🬲🬳🬴🬵🬶🬷🬸🬹🬺🬻█"

  # L59 - notcurses/ncseqs.h
  NCBRAILLEEGCS* =
    L("\u2800\u2801\u2808\u2809\u2802\u2803\u280a\u280b\u2810\u2811\u2818\u2819\u2812\u2813\u281a\u281b" &
      "\u2804\u2805\u280c\u280d\u2806\u2807\u280e\u280f\u2814\u2815\u281c\u281d\u2816\u2817\u281e\u281f" &
      "\u2820\u2821\u2828\u2829\u2822\u2823\u282a\u282b\u2830\u2831\u2838\u2839\u2832\u2833\u283a\u283b" &
      "\u2824\u2825\u282c\u282d\u2826\u2827\u282e\u282f\u2834\u2835\u283c\u283d\u2836\u2837\u283e\u283f" &
      "\u2840\u2841\u2848\u2849\u2842\u2843\u284a\u284b\u2850\u2851\u2858\u2859\u2852\u2853\u285a\u285b" &
      "\u2844\u2845\u284c\u284d\u2846\u2847\u284e\u284f\u2854\u2855\u285c\u285d\u2856\u2857\u285e\u285f" &
      "\u2860\u2861\u2868\u2869\u2862\u2863\u286a\u286b\u2870\u2871\u2878\u2879\u2872\u2873\u287a\u287b" &
      "\u2864\u2865\u286c\u286d\u2866\u2867\u286e\u286f\u2874\u2875\u287c\u287d\u2876\u2877\u287e\u287f" &
      "\u2880\u2881\u2888\u2889\u2882\u2883\u288a\u288b\u2890\u2891\u2898\u2899\u2892\u2893\u289a\u289b" &
      "\u2884\u2885\u288c\u288d\u2886\u2887\u288e\u288f\u2894\u2895\u289c\u289d\u2896\u2897\u289e\u289f" &
      "\u28a0\u28a1\u28a8\u28a9\u28a2\u28a3\u28aa\u28ab\u28b0\u28b1\u28b8\u28b9\u28b2\u28b3\u28ba\u28bb" &
      "\u28a4\u28a5\u28ac\u28ad\u28a6\u28a7\u28ae\u28af\u28b4\u28b5\u28bc\u28bd\u28b6\u28b7\u28be\u28bf" &
      "\u28c0\u28c1\u28c8\u28c9\u28c2\u28c3\u28ca\u28cb\u28d0\u28d1\u28d8\u28d9\u28d2\u28d3\u28da\u28db" &
      "\u28c4\u28c5\u28cc\u28cd\u28c6\u28c7\u28ce\u28cf\u28d4\u28d5\u28dc\u28dd\u28d6\u28d7\u28de\u28df" &
      "\u28e0\u28e1\u28e8\u28e9\u28e2\u28e3\u28ea\u28eb\u28f0\u28f1\u28f8\u28f9\u28f2\u28f3\u28fa\u28fb" &
      "\u28e4\u28e5\u28ec\u28ed\u28e6\u28e7\u28ee\u28ef\u28f4\u28f5\u28fc\u28fd\u28f6\u28f7\u28fe\u28ff")

  # L76 - notcurses/ncseqs.h
  NCSEGDIGITS* =
    L("\u{0001fbf0}\u{0001fbf1}\u{0001fbf2}\u{0001fbf3}\u{0001fbf4}" &
      "\u{0001fbf5}\u{0001fbf6}\u{0001fbf7}\u{0001fbf8}\u{0001fbf9}")

  # L79 - notcurses/ncseqs.h
  NCSUITSBLACK* = L("\u2660\u2663\u2665\u2666") # ♠♣♥♦
  NCSUITSWHITE* = L("\u2661\u2662\u2664\u2667") # ♡♢♤♧
  NCCHESSBLACK* = L("\u265f\u265c\u265e\u265d\u265b\u265a") # ♟♜♞♝♛♚
  NCCHESSWHITE* = L("\u265f\u265c\u265e\u265d\u265b\u265a") # ♙♖♘♗♕♔
  NCDICE*       = L("\u2680\u2681\u2682\u2683\u2684\u2685") # ⚀⚁⚂⚃⚄⚅
  NCMUSICSYM*   = L("\u2669\u266A\u266B\u266C\u266D\u266E\u266F") # ♩♪♫♬♭♮♯

  # L87 - notcurses/ncseqs.h
  NCBOXLIGHT*  = "┌┐└┘─│".cstring
  NCBOXHEAVY*  = "┏┓┗┛━┃".cstring
  NCBOXROUND*  = "╭╮╰╯─│".cstring
  NCBOXDOUBLE* = "╔╗╚╝═║".cstring
  NCBOXASCII*  = "/\\\\/-|".cstring
  NCBOXOUTER*  = "🭽🭾🭼🭿▁🭵🭶🭰".cstring
