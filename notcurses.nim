# Eventually this module should export a high/er-level "Nim oriented" API.
# For now it's a thin wrapper around the "plain vanilla" wrapper around
# Notcurses C ABI... and some niceties in the direction of a high/er-level API.

# consider how to eliminate duplication in notcurses.nim and notcurses/core.nim

{.push raises: [Defect].}

import std/[atomics, bitops]

import ./notcurses/[abi, constants, vendor/stew/results]

export constants, results

type
  Notcurses* = object
    ncPtr: ptr notcurses

  NotcursesError* = enum
    RenderError = "Notcurses.render failed!"
    StopError = "Notcurses.stop failed!"

  Options* = object
    opts: notcurses_options

const
  AlreadyInitialized = "Notcurses is already initialized!"
  FailedInitialize = "Notcurses failed to initialize!"
  FailureNotExpected = "failure not expected"
  NotInitialized = "Notcurses is not initialized!"

var
  ncObject {.threadvar.}: Notcurses
  ncPtr: Atomic[ptr notcurses]

proc acquire*(T: type Notcurses): T =
  if ncObject.ncPtr.isNil:
    let p = ncPtr.load
    if p.isNil:
      raise newException(Defect, NotInitialized)
    else:
      ncObject = T(ncPtr: p)
  ncObject

func expect*(res: Result[void, NotcursesError]) =
  expect(res, FailureNotExpected)

proc init*(T: type Options , options: varargs[Ncoption]): T =
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

proc init*(T: type Notcurses, opts: Options, file: File = stdout): T =
  var p = ncPtr.load
  if not p.isNil:
    raise newException(Defect, AlreadyInitialized)
  else:
    let nc = notcurses_init(unsafeAddr opts.opts, file)
    if nc.isNil: raise newException(Defect, FailedInitialize)
    ncObject = T(ncPtr: nc)
    if not ncPtr.exchange(ncObject.ncPtr).isNil:
      raise newException(Defect, AlreadyInitialized)
    ncObject

proc render*(nc: Notcurses): Result[void, NotcursesError] =
  if nc.ncPtr.notcurses_render() < 0:
    err(RenderError)
  else:
    ok()

proc stop*(nc: Notcurses): Result[void, NotcursesError] =
  if nc.ncPtr.notcurses_stop() < 0:
    err(StopError)
  else:
    ok()
