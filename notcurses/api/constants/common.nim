import pkg/stew/byteutils
import ../../abi/constants/common
import ../../abi/constants/version

type
  DefectMessages* {.pure.} = enum
    FailureNotExpected = "failure not expected"
    InvalidCodepoint = "invalid Notcurses codepoint"
    InvalidUcs32 = "invalid UCS32 codepoint"
    NcStop = "notcurses_stop failed"
    NcdStop = "ncdirect_stop failed"

  Style* = distinct uint32

  Styles* {.pure.} = enum
    None = Style(NCSTYLE_NONE)
    Struck = Style(NCSTYLE_STRUCK)
    Bold = Style(NCSTYLE_BOLD)
    Undercurl = Style(NCSTYLE_UNDERCURL)
    Underline = Style(NCSTYLE_UNDERLINE)
    Italic = Style(NCSTYLE_ITALIC)
    Mask = Style(NCSTYLE_MASK)

  Ucs32* = distinct uint32

const
  HighUcs32* = Ucs32(0x0010ffff'u32)

  NimNotcursesMajor* = nim_notcurses_version.major.int
  NimNotcursesMinor* = nim_notcurses_version.minor.int
  NimNotcursesPatch* = nim_notcurses_version.patch.int

  # https://codepoints.net/U+FFFD
  ReplacementChar* = string.fromBytes hexToByteArray("0xefbfbd", 3)
