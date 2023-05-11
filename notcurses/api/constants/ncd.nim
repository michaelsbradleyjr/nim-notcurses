import ../../abi/constants/ncd

type
  InitFlag* = distinct uint64

  InitFlags* {.pure.} = enum
    InhibitSetlocale = InitFlag(NCDIRECT_OPTION_INHIBIT_SETLOCALE)
    InhibitCbreak = InitFlag(NCDIRECT_OPTION_INHIBIT_CBREAK)
    DrainInput = InitFlag(NCDIRECT_OPTION_DRAIN_INPUT)
    NoQuitSighandlers = InitFlag(NCDIRECT_OPTION_NO_QUIT_SIGHANDLERS)
    Verbose = InitFlag(NCDIRECT_OPTION_VERBOSE)
    VeryVerbose = InitFlag(NCDIRECT_OPTION_VERY_VERBOSE)
