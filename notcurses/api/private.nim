when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises:[].}
else:
  {.push raises: [Defect].}

import std/[atomics, bitops, exitprocs, options]

import ./vendor/stew/[byteutils, results]

type
  Notcurses = object
    ncPtr: ptr notcurses

  NotcursesCodepoint = distinct uint32

  NotcursesDefect = object of Defect

  NotcursesError = object of CatchableError
    code*: cint

  NotcursesInput = object
    ni: ncinput

  NotcursesOptions = object
    opts: notcurses_options

  NotcursesPlane = object
    planePtr: ptr ncplane

  # only use Result[NotcursesSuccess, NotcursesError] in return type if success
  # code other than 0 is possible, otherwise use Result[void, NotcursesError];
  # might need an object hierarchy with NotcursesSuccess as the base, i.e. in
  # order to specialize if there's something other than a cint code used in
  # successful returns
  NotcursesSuccess = object
    code*: cint

var
  ncExitProcAdded: Atomic[bool]
  ncObject {.threadvar.}: Notcurses
  ncPtr: Atomic[ptr notcurses]
  ncStopped: Atomic[bool]

proc `$`(cp: NotcursesCodepoint): string =
  $cp.uint32

proc `$`(ni: NotcursesInput): string =
  $ni.ni

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

proc isKey(cp: NotcursesCodepoint): bool =
  let key = cp.uint32
  (key == Tab.uint32) or
  (key == Esc.uint32) or
  (key == Space.uint32) or
  (key >= Invalid.uint32 and key <= F60.uint32) or
  (key >= Enter.uint32 and key <= Separator.uint32) or
  (key >= CapsLock.uint32 and key <= L5Shift.uint32) or
  (key >= Motion.uint32 and key <= Button11.uint32) or
  (key == Signal.uint32) or
  (key == EOF.uint32)

proc isKey(ni: NotcursesInput): bool =
  ni.codepoint.isKey

proc isUTF8(cp: NotcursesCodepoint): bool =
  const highestPoint = 1114111.uint32
  cp.uint32 <= highestPoint

proc isUTF8(ni: NotcursesInput): bool =
  ni.codepoint.isUTF8

proc putString(plane: NotcursesPlane, s: string):
    Result[NotcursesSuccess, NotcursesError] {.discardable.} =
  let code = plane.planePtr.ncplane_putstr(s.cstring)
  if code <= 0:
    err NotcursesError(code: code, msg: $PutStr)
  else:
    ok NotcursesSuccess(code: code)

proc render(nc: Notcurses): Result[void, NotcursesError] =
  let code = nc.ncPtr.notcurses_render
  if code < 0:
    err NotcursesError(code: code, msg: $Render)
  else:
    ok()

proc setScrolling(plane: NotcursesPlane, enable: bool): bool {.discardable.} =
  plane.planePtr.ncplane_set_scrolling enable.cuint

proc stdPlane(nc: Notcurses): NotcursesPlane =
  let planePtr = nc.ncPtr.notcurses_stdplane
  NotcursesPlane(planePtr: planePtr)

proc stop(nc: Notcurses): Result[void, NotcursesError] =
  if ncStopped.load: raise (ref NotcursesDefect)(msg: $AlreadyStopped)
  let code = nc.ncPtr.notcurses_stop
  if code < 0:
    err NotcursesError(code: code, msg: $Stop)
  elif ncStopped.exchange(true):
    raise (ref NotcursesDefect)(msg: $AlreadyStopped)
  else:
    ok()

proc stopNotcurses() {.noconv.} =
  Notcurses.get.stop.expect

template addExitProc(T: type Notcurses) =
  if not ncExitProcAdded.exchange(true): addExitProc stopNotcurses

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
