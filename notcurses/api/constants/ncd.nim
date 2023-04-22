import ../../abi/constants/ncd

type
  InitOption* = distinct uint64

  InitOptions* {.pure.} = enum
    InhibitSetlocale = NCDIRECT_OPTION_INHIBIT_SETLOCALE.InitOption
    InhibitCbreak = NCDIRECT_OPTION_INHIBIT_CBREAK.InitOption
    DrainInput = NCDIRECT_OPTION_DRAIN_INPUT.InitOption
    NoQuitSighandlers = NCDIRECT_OPTION_NO_QUIT_SIGHANDLERS.InitOption
    Verbose = NCDIRECT_OPTION_VERBOSE.InitOption
    VeryVerbose = NCDIRECT_OPTION_VERY_VERBOSE.InitOption
