when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import pkg/stew/byteutils
import ./abi/wide

export wide except toSeqB, toSeqDbW

# `func toSeqB` from abi/wide assumes encoding of wide string `s` is valid, so
# `fromWide` has somewhat limited use cases
func fromWide*(T: type string, s: openArray[Wchar]): T =
  string.fromBytes s.toSeqB

# `func toSeqDbW` from abi/wide assumes encoding of multibyte string `s` is
# valid UTF-8, so `toWide` has somewhat limited use cases
# !!! impl me !!!
# func toWide*(s: string): ... =
