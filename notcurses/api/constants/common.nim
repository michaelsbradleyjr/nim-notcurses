import pkg/stew/byteutils
import ../../abi/constants/common
import ../../abi/constants/version

type
  DefectMessages* {.pure.} = enum
    FailureNotExpected = "failure not expected"
    InvalidCodepoint = "invalid Notcurses codepoint"
    InvalidUcs32 = "invalid UCS32 codepoint"
    NotcursesFailedToInitialize = "Notcurses failed to initialize"
    NotcursesFailedToStop = "Notcurses failed to stop"
    NotcursesDirectFailedToInitialize = "NotcursesDirect failed to initialize"
    NotcursesDirectFailedToStop = "NotcursesDirect failed to stop"

  Style* = distinct uint32

  Styles* {.pure.} = enum
    None = NCSTYLE_NONE.Style
    Struck = NCSTYLE_STRUCK.Style
    Bold = NCSTYLE_BOLD.Style
    Undercurl = NCSTYLE_UNDERCURL.Style
    Underline = NCSTYLE_UNDERLINE.Style
    Italic = NCSTYLE_ITALIC.Style
    Mask = NCSTYLE_MASK.Style

  Ucs32* = distinct uint32

const
  HighUcs32* = 0x0010ffff'u32.Ucs32

  NimNotcursesMajor* = nim_notcurses_version.major.int
  NimNotcursesMinor* = nim_notcurses_version.minor.int
  NimNotcursesPatch* = nim_notcurses_version.patch.int

  # https://codepoints.net/U+FFFD
  ReplacementChar* = string.fromBytes hexToByteArray("0xefbfbd", 3)
