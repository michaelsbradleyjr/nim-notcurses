# consider how to eliminate duplication in notcurses.nim and notcurses/core.nim

# should implement top-level policy re: {.push raises: [...].} but it's not
# working as expected, maybe because of changes in Nim v1.6 or aspects I have
# yet to understand properly; need to investigate further.

# {.push raises: [Defect].}
# {.push raises: [].}

import std/[atomics, bitops]

import ./notcurses/[abi, constants, vendor/stew/results]

export InitOption, InitOptions, results

type
 Notcurses* = object
   # don't want this field public, fix with more use of include vs. import
   ncPtr*: ptr notcurses

 NotcursesDefect* = object of Defect

 NotcursesError* = object of CatchableError
   code*: cint

 NotcursesInput* = object
   # don't want this field public, fix with more use of include vs. import
   ni*: ncinput

 NotcursesOptions* = object
   # don't want this field public, fix with more use of include vs. import
   opts*: notcurses_options

 NotcursesPlane* = object
   # don't want this field public, fix with more use of include vs. import
   planePtr*: ptr ncplane

 # only use Result[NotcursesSuccess, NotcursesError] in return type if success
 # code other than 0 is possible, otherwise use Result[void, NotcursesError]
 NotcursesSuccess* = object
   code*: cint

var
 ncObject {.threadvar.}: Notcurses
 ncPtr: Atomic[ptr notcurses]

proc evType*(ni: NotcursesInput): cint =
  ni.ni.evtype

proc expect*(res: Result[void, NotcursesError]) =
 expect(res, $DefectMessages.FailureNotExpected)

proc get*(T: type Notcurses): T =
 if ncObject.ncPtr.isNil:
   let ncP = ncPtr.load
   if ncP.isNil:
     raise (ref NotcursesDefect)(msg: $DefectMessages.NotInitialized)
   else:
     ncObject = T(ncPtr: ncP)
 ncObject

proc getBlocking*(nc: Notcurses, ni: var NotcursesInput): uint32
    {.discardable.} =
  nc.ncPtr.notcurses_get_blocking(unsafeAddr ni.ni)

proc init*(T: type NotcursesInput): T =
  T(ni: ncinput())

proc getBlocking*(nc: Notcurses): NotcursesInput {.discardable.} =
  var ni = NotcursesInput.init
  nc.getBlocking ni
  ni

proc id*(ni: NotcursesInput): uint32 =
  ni.ni.id

proc init*(T: type NotcursesOptions , options: varargs[InitOptions]): T =
 var opts: culonglong
 if options.len == 0:
   opts = 0.culonglong
 elif options.len == 1:
   opts = options[0].culonglong
 else:
   opts = options[0].culonglong
   for o in options[1..^1]:
     opts = bitor(opts, o.culonglong)
 T(opts: notcurses_options(flags: opts))

proc init*(T: type Notcurses, opts: NotcursesOptions = NotcursesOptions.init,
   file: File = stdout): T =
 if not ncObject.ncPtr.isNil or not ncPtr.load.isNil:
   raise (ref NotcursesDefect)(msg: $DefectMessages.AlreadyInitialized)
 else:
   let ncP = notcurses_init(unsafeAddr opts.opts, file)
   if ncP.isNil: raise (ref NotcursesDefect)(
     msg: $DefectMessages.FailedToInitialize)
   ncObject = T(ncPtr: ncP)
   if not ncPtr.exchange(ncObject.ncPtr).isNil:
     raise (ref NotcursesDefect)(msg: $DefectMessages.AlreadyInitialized)
   ncObject

proc putStr*(plane: NotcursesPlane, s: string): Result[void, NotcursesError] =
 let code = plane.planePtr.ncplane_putstr(s.cstring)
 if code < 0:
  err NotcursesError(code: code, msg: $ErrorMessages.PutStr)
 else:
   ok()

proc render*(nc: Notcurses): Result[void, NotcursesError] =
 let code = nc.ncPtr.notcurses_render
 if code < 0:
   err NotcursesError(code: code, msg: $ErrorMessages.Render)
 else:
   ok()

proc setScrolling*(plane: NotcursesPlane, enable: bool): bool {.discardable.} =
 plane.planePtr.ncplane_set_scrolling enable.cuint

proc stdPlane*(nc: Notcurses): NotcursesPlane =
 let planePtr = nc.ncPtr.notcurses_stdplane
 NotcursesPlane(planePtr: planePtr)

proc stop*(nc: Notcurses): Result[void, NotcursesError] =
 let code = nc.ncPtr.notcurses_stop
 if code < 0:
   err NotcursesError(code: code, msg: $ErrorMessages.Stop)
 else:
   ok()

# Friendly aliases: should foment joy, curtail if a source of lamentations;
# limit to intuitive shortenings
# consider renaming InitOption/s to NotcursesInitOption/s and shorten from there
type
 Nc* = Notcurses
 NcDefect* = NotcursesDefect
 NcErr* = NotcursesError
 NcError* = NotcursesError
 NcInitOption* = InitOption
 NcInitOptions* = InitOptions
 NcInitOpt* = InitOption
 NcInitOpts* = InitOptions
 NcInput* = NotcursesInput
 NcOption* = InitOption
 NcOpt* = InitOption
 NcOpts* = NotcursesOptions
 NcOptions* = NotcursesOptions
 NcPlane* = NotcursesPlane
 NcSuc* = NotcursesSuccess
 NcSucc* = NotcursesSuccess
 NcSuccess* = NotcursesSuccess
 ncoption* = InitOption

const putString* = putStr
