# should implement top-level policy re: {.push raises: [...].} but it's not
# working as expected, maybe because of changes in Nim v1.6 or aspects I have
# yet to understand properly; need to investigate further.

# {.push raises: [Defect].}
# {.push raises: [].}

import std/[atomics, bitops]

import ./vendor/stew/results

include ./private/constants

type
  Notcurses = object
    ncPtr: ptr notcurses

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
  ncObject {.threadvar.}: Notcurses
  ncPtr: Atomic[ptr notcurses]

proc evType(ni: NotcursesInput): cint =
  ni.ni.evtype

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

proc id(ni: NotcursesInput): uint32 =
  ni.ni.id

proc putStr(plane: NotcursesPlane, s: string):
    Result[NotcursesSuccess, NotcursesError] {.discardable.} =
  let code = plane.planePtr.ncplane_putstr(s.cstring)
  if code < 0:
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
  let code = nc.ncPtr.notcurses_stop
  if code < 0:
    err NotcursesError(code: code, msg: $Stop)
  else:
    ok()

proc stopNotcurses() {.noconv.} =
  Notcurses.get.stop.expect
