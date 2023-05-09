when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[hashes, sets]
import pkg/stew/results
import ../abi/common
import ../locale
import ../wide
import ./constants

export locale, results, wide

type
  ApiDefect* = object of Defect

  ApiError* = object of CatchableError

  ApiErrorCode* = object of ApiError
    code*: int32

  ApiSuccess* = int32

  Channel* = distinct uint32

  ChannelPair* = distinct uint64

  Codepoint* = distinct uint32

  PseudoCodepoint* = char | uint8 | uint16 | uint32

  # Aliases
  NcChannel* = Channel
  NcChannels* = ChannelPair

let
  LibNotcursesMajor* = lib_notcurses_major.int
  LibNotcursesMinor* = lib_notcurses_minor.int
  LibNotcursesPatch* = lib_notcurses_patch.int
  LibNotcursesTweak* = lib_notcurses_tweak.int

func `<`*(x, y: Codepoint): bool =
  x.uint32 < y.uint32
func `<=`*(x, y: Codepoint): bool =
  x.uint32 <= y.uint32
func `==`*(x, y: Codepoint): bool =
  x.uint32 == y.uint32

func `<`*(x: Codepoint | Ucs32, y: PseudoCodepoint): bool =
  x.uint32 < y.uint32
func `<=`*(x: Codepoint | Ucs32, y: PseudoCodepoint): bool =
  x.uint32 <= y.uint32
func `==`*(x: Codepoint | Ucs32, y: PseudoCodepoint): bool =
  x.uint32 == y.uint32

func `<`*(x: Codepoint, y: Ucs32): bool =
  x.uint32 < y.uint32
func `<=`*(x: Codepoint, y: Ucs32): bool =
  x.uint32 <= y.uint32
func `==`*(x: Codepoint, y: Ucs32): bool =
  x.uint32 == y.uint32

func `<`*(x: PseudoCodepoint, y: Codepoint | Ucs32): bool =
  x.uint32 < y.uint32
func `<=`*(x: PseudoCodepoint, y: Codepoint | Ucs32): bool =
  x.uint32 <= y.uint32
func `==`*(x: PseudoCodepoint, y: Codepoint | Ucs32): bool =
  x.uint32 == y.uint32

func `<`*(x: Ucs32, y: Codepoint): bool =
  x.uint32 < y.uint32
func `<=`*(x: Ucs32, y: Codepoint): bool =
  x.uint32 <= y.uint32
func `==`*(x: Ucs32, y: Codepoint): bool =
  x.uint32 == y.uint32

func `<`*(x, y: Ucs32): bool =
  x.uint32 < y.uint32
func `<=`*(x, y: Ucs32): bool =
  x.uint32 <= y.uint32
func `==`*(x, y: Ucs32): bool =
  x.uint32 == y.uint32

func contains*(s: HashSet[uint32]; key: Codepoint | Ucs32): bool =
  s.contains key.uint32

proc expect*[T: ApiSuccess, E: ApiError](res: Result[T, E],
    m = $FailureNotExpected): T {.discardable.} =
  results.expect(res, m)

proc expect*[E: ApiError](res: Result[void, E], m = $FailureNotExpected) =
  results.expect(res, m)

proc hash*(m: KeyModifiers | Styles): Hash =
  m.uint32.hash
