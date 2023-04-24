# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include

# this module uses extra whitespace so it can be visually scanned more easily

const
  # L29 - notcurses/direct.h
  NCDIRECT_OPTION_INHIBIT_SETLOCALE*   = 0x0000000000000001'u64
  NCDIRECT_OPTION_INHIBIT_CBREAK*      = 0x0000000000000002'u64
  NCDIRECT_OPTION_DRAIN_INPUT*         = 0x0000000000000004'u64
  NCDIRECT_OPTION_NO_QUIT_SIGHANDLERS* = 0x0000000000000008'u64
  NCDIRECT_OPTION_VERBOSE*             = 0x0000000000000010'u64
  NCDIRECT_OPTION_VERY_VERBOSE*        = 0x0000000000000020'u64
