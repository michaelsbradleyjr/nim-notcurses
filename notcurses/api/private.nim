when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises:[].}
else:
  {.push raises: [Defect].}

import std/[atomics, bitops, options]

import ./vendor/stew/[byteutils, results]

type
  LibNotcursesVersion = tuple[major, minor, patch, tweak: int]

  Notcurses = object
    ncPtr: ptr notcurses

  NotcursesCodepoint = distinct uint32

  NotcursesDefect = object of Defect

  NotcursesError = object of CatchableError
    code*: int

  NotcursesInput = object
    ni: ncinput

  NotcursesOptions = object
    opts: notcurses_options

  NotcursesPlane = object
    npPtr: ptr ncplane

  # use Result[NotcursesSuccess, NotcursesError] in return type if success can
  # be indicated by more than one value (e.g. something other than "only 0" or
  # "only 1"), otherwise use Result[void, NotcursesError]; might need an object
  # hierarchy with NotcursesSuccess as the base, i.e. in order to specialize if
  # there's something other than a cint value used in successful returns
  NotcursesSuccess = object
    code*: int


const
  NimNotcursesMajor = nim_notcurses_version.major.int
  NimNotcursesMinor = nim_notcurses_version.minor.int
  NimNotcursesPatch = nim_notcurses_version.patch.int

var
  lib_notcurses_major: cint
  lib_notcurses_minor: cint
  lib_notcurses_patch: cint
  lib_notcurses_tweak: cint

notcurses_version_components(addr lib_notcurses_major, addr lib_notcurses_minor,
  addr lib_notcurses_patch, addr lib_notcurses_tweak)

let
  LibNotcursesMajor = lib_notcurses_major.int
  LibNotcursesMinor = lib_notcurses_minor.int
  LibNotcursesPatch = lib_notcurses_patch.int
  LibNotcursesTweak = lib_notcurses_tweak.int

var
  ncExitProcAdded: Atomic[bool]
  ncObject {.threadvar.}: Notcurses
  ncPtr: Atomic[ptr notcurses]
  ncStopped: Atomic[bool]

proc `$`(ncp: NotcursesCodepoint): string =
  $ncp.uint32

proc `$`(ni: NotcursesInput): string =
  $ni.ni

proc `$`(opts: NotcursesOptions): string =
  $opts.opts

proc codepoint(ni: NotcursesInput): NotcursesCodepoint =
  ni.ni.id.NotcursesCodepoint

proc event(ni: NotcursesInput): NotcursesInputEvents =
  cast[NotcursesInputEvents](ni.ni.evtype)

proc expect(res: Result[NotcursesSuccess, NotcursesError]):
    NotcursesSuccess {.discardable.} =
  expect(res, $FailureNotExpected)

proc expect(res: Result[void, NotcursesError]) =
  expect(res, $FailureNotExpected)

proc get(T: type Notcurses): T =
  if ncObject.ncPtr.isNil:
    let ncP = ncPtr.load
    if ncP.isNil:
      raise (ref NotcursesDefect)(msg: $NotInitialized)
    else:
      ncObject = T(ncPtr: ncP)
  ncObject

proc getBlocking(nc: Notcurses, ni: var NotcursesInput): uint32
    {.discardable.} =
  nc.ncPtr.notcurses_get_blocking(unsafeAddr ni.ni)

proc init(T: type NotcursesInput): T =
  T(ni: ncinput())

proc getBlocking(nc: Notcurses): NotcursesInput {.discardable.} =
  var ni = NotcursesInput.init
  nc.getBlocking ni
  ni

proc isKey(ncp: NotcursesCodepoint): bool =
  let key = ncp.uint32
  (key == NotcursesKeys.Tab.uint32) or
  (key == NotcursesKeys.Esc.uint32) or
  (key == NotcursesKeys.Space.uint32) or
  (key >= NotcursesKeys.Invalid.uint32 and
   key <= NotcursesKeys.F60.uint32) or
  (key >= NotcursesKeys.Enter.uint32 and
   key <= NotcursesKeys.Separator.uint32) or
  (key >= NotcursesKeys.CapsLock.uint32 and
   key <= NotcursesKeys.L5Shift.uint32) or
  (key >= NotcursesKeys.Motion.uint32 and
   key <= NotcursesKeys.Button11.uint32) or
  (key == NotcursesKeys.Signal.uint32) or
  (key == NotcursesKeys.EOF.uint32)

proc isKey(ni: NotcursesInput): bool =
  ni.codepoint.isKey

proc isUTF8(ncp: NotcursesCodepoint): bool =
  const highestPoint = 1114111.uint32
  ncp.uint32 <= highestPoint

proc isUTF8(ni: NotcursesInput): bool =
  ni.codepoint.isUTF8

proc libVersion(T: type Notcurses): LibNotcursesVersion =
  var major, minor, patch, tweak: cint
  notcurses_version_components(addr major, addr minor, addr patch, addr tweak)
  (major: major.int, minor: minor.int, patch: patch.int, tweak: tweak.int)

proc libVersionString(T: type Notcurses): string =
  $notcurses_version()

proc putString(np: NotcursesPlane, s: string):
    Result[NotcursesSuccess, NotcursesError] {.discardable.} =
  let code = np.npPtr.ncplane_putstr(s.cstring)
  if code <= 0.cint:
    err NotcursesError(code: code.int, msg: $PutStr)
  else:
    ok NotcursesSuccess(code: code.int)

proc render(nc: Notcurses): Result[void, NotcursesError] =
  let code = nc.ncPtr.notcurses_render
  if code < 0.cint:
    err NotcursesError(code: code.int, msg: $Render)
  else:
    ok()

proc setScrolling(np: NotcursesPlane, enable: bool): bool {.discardable.} =
  np.npPtr.ncplane_set_scrolling enable.cuint

proc stdPlane(nc: Notcurses): NotcursesPlane =
  let npPtr = nc.ncPtr.notcurses_stdplane
  NotcursesPlane(npPtr: npPtr)

proc stop(nc: Notcurses): Result[void, NotcursesError] =
  if ncStopped.load: raise (ref NotcursesDefect)(msg: $AlreadyStopped)
  let code = nc.ncPtr.notcurses_stop
  if code < 0.cint:
    err NotcursesError(code: code.int, msg: $Stop)
  elif ncStopped.exchange(true):
    raise (ref NotcursesDefect)(msg: $AlreadyStopped)
  else:
    ok()

proc stopNotcurses() {.noconv.} =
  Notcurses.get.stop.expect

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  import std/exitprocs

  template addExitProc(T: type Notcurses) =
    if not ncExitProcAdded.exchange(true): addExitProc stopNotcurses

else:
  template addExitProc(T: type Notcurses) =
    if not ncExitProcAdded.exchange(true): addQuitProc stopNotcurses

proc toKey(ni: NotcursesInput): Option[NotcursesKeys] =
  if ni.isKey: some(cast[NotcursesKeys](ni.codepoint))
  else: none[NotcursesKeys]()

proc toUTF8(ni: NotcursesInput): Option[string] =
  if ni.isUTF8:
    var bytes: seq[byte]
    const nullC = '\x00'.cchar
    bytes.add ni.ni.utf8[0].byte
    for c in ni.ni.utf8[1..3]:
      if c != nullC: bytes.add c.byte
      else: break
    some(string.fromBytes bytes)
  else:
    none[string]()
