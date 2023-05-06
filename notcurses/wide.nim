when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import pkg/stew/byteutils
import ./abi/wide

export wide except toSeqB, toSeqW

# `func toSeqB` from abi/wide assumes encoding of wide string `ws` is valid, so
# `fromWide` has somewhat limited use cases
func fromWide*(T: typedesc[string], ws: openArray[Wchar]): T =
  T.fromBytes ws.toSeqB

func fromWide*(T: typedesc[string], ws: ptr UncheckedArray[Wchar]): T =
  T.fromBytes ws.toSeqB

# `func toSeqW` from abi/wide assumes encoding of multibyte string `s` is valid
# UTF-8, so `toWide` has somewhat limited use cases
proc toWide*(s: string, wcs: var seq[Wchar]): ptr UncheckedArray[Wchar] =
  wcs = s.toSeqW
  wcs.add 0.wchar
  cast[ptr UncheckedArray[Wchar]](addr wcs[0])
