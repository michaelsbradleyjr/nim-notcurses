# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include

# this module uses extra whitespace so it can be visually scanned more easily

{.push raises: [].}

# L31 - notcurses/nckeys.h
const PRETERUNICODEBASE* = 1115000'u32

# L32 - notcurses/nckeys.h
func preterunicode(w: uint32): uint32 {.compileTime.} = w + PRETERUNICODEBASE

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

const
  # L192 - notcurses/nckeys.h
  NCKEY_SCROLL_UP*    = NCKEY_BUTTON4
  NCKEY_SCROLL_DOWN*  = NCKEY_BUTTON5
  NCKEY_RETURN*       = NCKEY_ENTER

const
  # L219 - notcurses/nckeys.h
  NCKEY_MOD_SHIFT*    =   1'u32
  NCKEY_MOD_ALT*      =   2'u32
  NCKEY_MOD_CTRL*     =   4'u32
  NCKEY_MOD_SUPER*    =   8'u32
  NCKEY_MOD_HYPER*    =  16'u32
  NCKEY_MOD_META*     =  32'u32
  NCKEY_MOD_CAPSLOCK* =  64'u32
  NCKEY_MOD_NUMLOCK*  = 128'u32
