# consider how to eliminate duplication in notcurses.nim and notcurses/core.nim

# should implement top-level policy re: {.push raises: [...].} but it's not
# working as expected, maybe because of changes in Nim v1.6 or aspects I have
# yet to understand properly; need to investigate further.

# {.push raises: [Defect].}
# {.push raises: [].}

import std/[atomics, bitops]

# will this syntax work in Nim version < 1.6, 1.4?
import ./notcurses/[abi, constants, vendor/stew/results]

export constants, results

type
  Notcurses* = object
    ncPtr: ptr notcurses
  NotcursesOptions* = object
    opts: notcurses_options
  # only use Result[V, E] in return type if success code other than 0 is
  # possible, otherwise use Result[void, E]
  NotcursesSuccess* = object
    code*: int

# Defects
type
  NotcursesDefect* = object of Defect

# Errors
type
  NotcursesError* = object of CatchableError
    code*: int
  NotcursesErrorRender* = object of NotcursesError
  NotcursesErrorStop* = object of NotcursesError

# Friendly aliases: should foment joy, curtail if a source of lamentations
# Limit to intuitive shortenings
type
  Nc* = Notcurses
  NcDefect* = NotcursesDefect
  NcErr* = NotcursesError
  NcError* = NotcursesError
  NcOpts* = NotcursesOptions
  NcOptions* = NotcursesOptions
  NcRenderErr* = NotcursesErrorRender
  NcRenderError* = NotcursesErrorRender
  NcStopErr* = NotcursesErrorStop
  NcStopError* = NotcursesErrorStop
  NcSuc* = NotcursesSuccess
  NcSucc* = NotcursesSuccess
  NcSuccess* = NotcursesSuccess
  NotcursesRenderErr* = NotcursesErrorRender
  NotcursesRenderError* = NotcursesErrorRender
  NotcursesStopErr* = NotcursesErrorStop
  NotcursesStopError* = NotcursesErrorStop

# Defect messages
const
  AlreadyInitialized = "Notcurses is already initialized!"
  FailedToInitialize = "Notcurses failed to initialize!"
  FailureNotExpected = "failure not expected"
  NotInitialized = "Notcurses is not initialized!"

# Error messages
const
  ErrorRenderMsg = "Notcurses.render failed!"
  ErrorStopMsg = "Notcurses.stop failed!"

var
  ncObject {.threadvar.}: Notcurses
  ncPtr: Atomic[ptr notcurses]

proc expect*(res: Result[void, NotcursesError]) =
  expect(res, FailureNotExpected)

proc get*(T: type Notcurses): T =
  if ncObject.ncPtr.isNil:
    let ncP = ncPtr.load
    if ncP.isNil:
      raise (ref NotcursesDefect)(msg: NotInitialized)
    else:
      ncObject = T(ncPtr: ncP)
  ncObject

proc init*(T: type Notcurses, opts: NotcursesOptions, file: File = stdout): T =
  if not ncObject.ncPtr.isNil or not ncPtr.load.isNil:
    raise (ref NotcursesDefect)(msg: AlreadyInitialized)
  else:
    let ncP = notcurses_init(unsafeAddr opts.opts, file)
    if ncP.isNil: raise (ref NotcursesDefect)(msg: FailedToInitialize)
    ncObject = T(ncPtr: ncP)
    if not ncPtr.exchange(ncObject.ncPtr).isNil:
      raise (ref NotcursesDefect)(msg: AlreadyInitialized)
    ncObject

proc init*(T: type NotcursesOptions , options: varargs[Ncoption]): T =
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

proc render*(nc: Notcurses): Result[void, NotcursesError] =
  let code = nc.ncPtr.notcurses_render.int
  if code < 0:
    err NotcursesErrorRender(code: code, msg: ErrorRenderMsg)
  else:
    ok()

proc stop*(nc: Notcurses): Result[void, NotcursesError] =
  let code = nc.ncPtr.notcurses_stop.int
  if code < 0:
    err NotcursesErrorStop(code: code, msg: ErrorStopMsg)
  else:
    ok()
