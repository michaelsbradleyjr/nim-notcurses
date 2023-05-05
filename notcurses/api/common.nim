when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/atomics
import std/sets
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

  InitStatus {.pure.} = enum
    ncInited = "Notcurses is initialized"
    ncIniting = "Notcurses is initializing"
    ncStopping = "Notcurses is stopped"
    ncdInited = "NotcursesDirect is initialized"
    ncdIniting = "NotcursesDirect is initializing"
    ncdStopping = "NotcursesDirect is stopping"
    stopped = "neither Notcurses nor NotcursesDirect is initialized"
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

var initStatus: Atomic[InitStatus]
initStatus.store(stopped)

proc isNcInited*(): bool =
  initStatus.load == ncInited

proc isNcdInited*(): bool =
  initStatus.load == ncdInited

proc setInitStatus(status: InitStatus): InitStatus =
  initStatus.exchange(status)

proc setNcInited*() =
  let prevStatus = setInitStatus(ncInited)
  if prevStatus != ncIniting:
    let msg =
      "fatal race condition: cannot finish initializing Notcurses when " &
      $prevStatus
    raise (ref ApiDefect)(msg: msg)

proc setNcIniting*() =
  let prevStatus = setInitStatus(ncIniting)
  if prevStatus != stopped:
    let msg =
      "fatal race condition: cannot initialize Notcurses when " &
      $prevStatus
    raise (ref ApiDefect)(msg: msg)

proc setNcStopped*() =
  let prevStatus = setInitStatus(stopped)
  if prevStatus != ncStopping:
    let msg =
      "fatal race condition: cannot finish stopping Notcurses when " &
      $prevStatus
    raise (ref ApiDefect)(msg: msg)

proc setNcStopping*() =
  let prevStatus = setInitStatus(ncStopping)
  if prevStatus != ncInited:
    let msg = "fatal race condition: cannot stop Notcurses when " & $prevStatus
    raise (ref ApiDefect)(msg: msg)

proc setNcdInited*() =
  let prevStatus = setInitStatus(ncdInited)
  if prevStatus != ncdIniting:
    let msg =
      "fatal race condition: cannot finish initializing NotcursesDirect when " &
      $prevStatus
    raise (ref ApiDefect)(msg: msg)

proc setNcdIniting*() =
  let prevStatus = setInitStatus(ncdIniting)
  if prevStatus != stopped:
    let msg =
      "fatal race condition: cannot initialize NotcursesDirect when " &
      $prevStatus
    raise (ref ApiDefect)(msg: msg)

proc setNcdStopped*() =
  let prevStatus = setInitStatus(stopped)
  if prevStatus != ncdStopping:
    let msg =
      "fatal race condition: cannot finish stopping NotcursesDirect when " &
      $prevStatus
    raise (ref ApiDefect)(msg: msg)

proc setNcdStopping*() =
  let prevStatus = setInitStatus(ncdStopping)
  if prevStatus != ncdInited:
    let msg =
      "fatal race condition: cannot stop NotcursesDirect when " & $prevStatus
    raise (ref ApiDefect)(msg: msg)
