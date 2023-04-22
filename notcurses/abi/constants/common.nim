# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include

# this module uses extra whitespace so it can be visually scanned more easily

const
  # L769 - notcurses/notcurses.h
  NCSTYLE_MASK*      = 0x0000ffff'u32
  NCSTYLE_ITALIC*    = 0x00000010'u32
  NCSTYLE_UNDERLINE* = 0x00000008'u32
  NCSTYLE_UNDERCURL* = 0x00000004'u32
  NCSTYLE_BOLD*      = 0x00000002'u32
  NCSTYLE_STRUCK*    = 0x00000001'u32
  NCSTYLE_NONE*      = 0x00000000'u32
