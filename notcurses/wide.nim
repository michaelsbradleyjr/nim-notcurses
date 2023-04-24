when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/sequtils
import pkg/stew/byteutils
import ./abi/wide

export wide except toSeqB, toSeqDbW

# `func toSeqB` from abi/wide assumes encoding of wide string `ws` is valid, so
# `fromWide` has somewhat limited use cases
func fromWide*(T: type string, ws: openArray[Wchar]): T =
  string.fromBytes ws.toSeqB

func fromWide*(T: type string, ws: ptr UncheckedArray[Wchar]): T =
  string.fromBytes ws.toSeqB

# `func toSeqDbW` from abi/wide assumes encoding of multibyte string `s` is
# valid UTF-8, so `toWide` has somewhat limited use cases
proc toWide*(s: string, wcs: var seq[Wchar]): ptr UncheckedArray[Wchar] =
  wcs = s.toSeqDbW.mapIt it.wchar
  wcs.add 0.wchar
  cast[ptr UncheckedArray[Wchar]](addr wcs[0])
