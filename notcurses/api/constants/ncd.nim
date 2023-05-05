import ../../abi/constants/ncd

type
  InitFlag* = distinct uint64

  InitFlags* {.pure.} = enum
    InhibitSetlocale = NCDIRECT_OPTION_INHIBIT_SETLOCALE.InitFlag
    InhibitCbreak = NCDIRECT_OPTION_INHIBIT_CBREAK.InitFlag
    DrainInput = NCDIRECT_OPTION_DRAIN_INPUT.InitFlag
    NoQuitSighandlers = NCDIRECT_OPTION_NO_QUIT_SIGHANDLERS.InitFlag
    Verbose = NCDIRECT_OPTION_VERBOSE.InitFlag
    VeryVerbose = NCDIRECT_OPTION_VERY_VERBOSE.InitFlag
