include ./abi/private/constants

type Ncoption* = distinct culonglong

const
  DrainInput* = NCOPTION_DRAIN_INPUT.Ncoption
  InhibitSetlocale* = NCOPTION_INHIBIT_SETLOCALE.Ncoption
  NoAlternateScreen* = NCOPTION_NO_ALTERNATE_SCREEN.Ncoption
  NoClearBitmaps* = NCOPTION_NO_CLEAR_BITMAPS.Ncoption
  NoFontChanges* = NCOPTION_NO_FONT_CHANGES.Ncoption
  NoQuitSighandlers* = NCOPTION_NO_QUIT_SIGHANDLERS.Ncoption
  NoWinchSighandler* = NCOPTION_NO_WINCH_SIGHANDLER.Ncoption
  PreserveCursor* = NCOPTION_PRESERVE_CURSOR.Ncoption
  SuppressBanners* = NCOPTION_SUPPRESS_BANNERS.Ncoption
