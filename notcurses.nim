# consider how to eliminate duplication in notcurses.nim and notcurses/core.nim

# should implement top-level policy re: {.push raises: [...].} but it's not
# working as expected, maybe because of changes in Nim v1.6 or aspects I have
# yet to understand properly; need to investigate further.

# {.push raises: [Defect].}
# {.push raises: [].}

import std/[atomics, bitops]

# will this syntax work in Nim version < 1.6, 1.4?
import ./notcurses/[abi, constants, vendor/stew/results]

export InitOptions, results

type
  Notcurses* = object
    ncPtr: ptr notcurses
  NotcursesDefect* = object of Defect
  NotcursesError* = object of CatchableError
    code*: int
  NotcursesOptions* = object
    opts: notcurses_options
  # only use Result[V, E] in return type if success code other than 0 is
  # possible, otherwise use Result[void, E]
  NotcursesSuccess* = object
    code*: int

# Friendly aliases: should foment joy, curtail if a source of lamentations;
# limit to intuitive shortenings
type
  Nc* = Notcurses
  NcDefect* = NotcursesDefect
  NcErr* = NotcursesError
  NcError* = NotcursesError
  NcInitOption* = InitOption
  NcInitOptions* = InitOptions
  NcInitOpt* = InitOption
  NcInitOpts* = InitOptions
  NcOption* = InitOption
  NcOpt* = InitOption
  NcOpts* = NotcursesOptions
  NcOptions* = NotcursesOptions
  NcSuc* = NotcursesSuccess
  NcSucc* = NotcursesSuccess
  NcSuccess* = NotcursesSuccess
  ncoption* = InitOption

var
  ncObject {.threadvar.}: Notcurses
  ncPtr: Atomic[ptr notcurses]

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

proc init*(T: type Notcurses, opts: NotcursesOptions, file: File = stdout): T =
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

proc render*(nc: Notcurses): Result[void, NotcursesError] =
  let code = nc.ncPtr.notcurses_render.int
  if code < 0:
    err NotcursesError(code: code, msg: $ErrorMessages.Render)
  else:
    ok()

proc stop*(nc: Notcurses): Result[void, NotcursesError] =
  let code = nc.ncPtr.notcurses_stop.int
  if code < 0:
    err NotcursesError(code: code, msg: $ErrorMessages.Stop)
  else:
    ok()
