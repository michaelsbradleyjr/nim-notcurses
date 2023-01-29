type
  DirectDefectMessages {.pure.} = enum
    DirectAddExitProcFailed  =
    when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
      "addExitProc raised an unknown exception"
    else:
      "addQuitProc raised an unknown exception"
    DirectAlreadyInitialized = "Notcurses is already initialized!"
    DirectAlreadyStopped     = "Notcurses is already stopped!"
    DirectFailedToInitialize = "Notcurses failed to initialize!"
    DirectFailureNotExpected = "failure not expected"
    DirectNotInitialized     = "Notcurses is not initialized!"

  DirectErrorMessages {.pure.} = enum
    DirectPutStr = "ncdirect_putstr failed!"
    DirectStop   = "ncdirect_stop failed!"

  DirectInitOption* = distinct uint64

  DirectInitOptions* {.pure.} = enum
    DirectInhibitSetlocale  = NCDIRECT_OPTION_INHIBIT_SETLOCALE
    DirectInhibitCbreak     = NCDIRECT_OPTION_INHIBIT_CBREAK
    DirectDrainInput        = NCDIRECT_OPTION_DRAIN_INPUT
    DirectNoQuitSighandlers = NCDIRECT_OPTION_NO_QUIT_SIGHANDLERS
    DirectVerbose           = NCDIRECT_OPTION_VERBOSE
    DirectVeryVerbose       = NCDIRECT_OPTION_VERY_VERBOSE
