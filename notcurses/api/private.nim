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

  NotcursesError0 = object of NotcursesError
    code*: range[low(cint).int..0]

  NotcursesErrorN = object of NotcursesError
    code*: range[low(cint).int..(-1)]

  NotcursesInput = object
    ni: ncinput

  NotcursesOptions = object
    opts: notcurses_options

  NotcursesPlane = object
    npPtr: ptr ncplane

  NotcursesSuccess = object of RootObj

  NotcursesSuccess0 = object of NotcursesSuccess
    code*: range[0..high(cint).int]

  NotcursesSuccessP = object of NotcursesSuccess
    code*: range[1..high(cint).int]

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

proc expect[T: NotcursesSuccess, E: NotcursesError](res: Result[T, E]):
    T {.discardable.} =
  expect(res, $FailureNotExpected)

proc expect[E: NotcursesError](res: Result[void, E]) =
  expect(res, $FailureNotExpected)

proc get(T: type Notcurses): T =
  if ncObject.ncPtr.isNil:
    let ncP = ncPtr.load
    if ncP.isNil:
      raise (ref NotcursesDefect)(msg: $NotInitialized)
    else:
      ncObject = T(ncPtr: ncP)
  ncObject

# when implementing api for notcurses_get, etc. (i.e. the abi calls that return
# 0.uint32 on timeout), use Option none for timeout and Option some
# NotcursesCodepoint otherwise

proc getBlocking(nc: Notcurses, ni: var NotcursesInput) =
  discard nc.ncPtr.notcurses_get_blocking(unsafeAddr ni.ni)

proc init(T: type NotcursesOptions, options: varargs[NotcursesInitOptions],
    term = "", logLevel: NotcursesLogLevels = NotcursesLogLevels.Panic,
    marginTop: uint32 = 0, marginRight: uint32 = 0, marginBottom: uint32 = 0,
    marginLeft: uint32 = 0): T =
  var flags = baseInitOption.culonglong
  if options.len >= 1:
    for o in options[0..^1]:
      flags = bitor(flags, o.culonglong)
  if term == "":
    T(opts: notcurses_options(loglevel: cast[ncloglevel_e](logLevel),
      margin_t: marginTop.cuint, margin_r: marginRight.cuint,
      margin_b: marginBottom.cuint, margin_l: marginLeft.cuint, flags: flags))
  else:
    T(opts: notcurses_options(termtype: term.cstring,
      loglevel: cast[ncloglevel_e](logLevel), margin_t: marginTop.cuint,
      margin_r: marginRight.cuint, margin_b: marginBottom.cuint,
      margin_l: marginLeft.cuint, flags: flags))

proc init(T: type Notcurses, opts: NotcursesOptions = NotcursesOptions.init,
    file: File = stdout): T =
  if not ncObject.ncPtr.isNil or not ncPtr.load.isNil:
    raise (ref NotcursesDefect)(msg: $AlreadyInitialized)
  else:
    let ncP = notcurses_init(unsafeAddr opts.opts, file)
    if ncP.isNil: raise (ref NotcursesDefect)(msg: $FailedToInitialize)
    ncObject = T(ncPtr: ncP)
    if not ncPtr.exchange(ncObject.ncPtr).isNil:
      raise (ref NotcursesDefect)(msg: $AlreadyInitialized)
    ncObject

proc init(T: type NotcursesInput): T =
  T(ni: ncinput())

proc getBlocking(nc: Notcurses): NotcursesInput =
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
    Result[NotcursesSuccessP, NotcursesError0] {.discardable.} =
  let code = np.npPtr.ncplane_putstr(s.cstring)
  if code <= 0.cint:
    err NotcursesError0(code: code.int, msg: $PutStr)
  else:
    ok NotcursesSuccessP(code: code.int)

proc render(nc: Notcurses): Result[void, NotcursesErrorN] =
  let code = nc.ncPtr.notcurses_render
  if code < 0.cint:
    err NotcursesErrorN(code: code.int, msg: $Render)
  else:
    ok()

proc setScrolling(np: NotcursesPlane, enable: bool): bool {.discardable.} =
  np.npPtr.ncplane_set_scrolling enable.cuint

proc stdPlane(nc: Notcurses): NotcursesPlane =
  let npPtr = nc.ncPtr.notcurses_stdplane
  NotcursesPlane(npPtr: npPtr)

proc stop(nc: Notcurses): Result[void, NotcursesErrorN] =
  if ncStopped.load: raise (ref NotcursesDefect)(msg: $AlreadyStopped)
  let code = nc.ncPtr.notcurses_stop
  if code < 0.cint:
    err NotcursesErrorN(code: code.int, msg: $Stop)
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
