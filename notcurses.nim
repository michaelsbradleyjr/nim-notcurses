# Eventually this module should export a high/er-level "Nim oriented" API.
# For now it's a thin wrapper around the "plain vanilla" wrapper around
# Notcurses C ABI... and some niceties in the direction of a high/er-level API.

# consider how to eliminate duplication in notcurses.nim and notcurses/core.nim

# procs here and in notcurses/core.nim whose wrapped function returns numerical
# status code should probably use Result

# provide a rawPointer func for type Notcurses and an init that takes the raw
# pointer instead of options and file; will facilitate e.g. communicating nc
# pointer to another thread and building a Notcurses instance without
# re-initialization (which would fail, since notcurses can only be init'd once
# per process)

import std/bitops

import ./notcurses/[abi, constants]

export constants

type
  Notcurses* = object
    nc: ptr notcurses
  Options* = object
    opts: notcurses_options

var initd = false

func init*(T: type Options , options: varargs[Ncoption]): T =
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
  if initd: raise newException(Defect, "Notcurses is already initialized!")
  let nc = notcurses_init(unsafeAddr opts.opts, file)
  if isNil(nc): raise newException(Defect, "Notcurses failed to initialize!")
  initd = true
  T(nc: nc)

proc render*(nc: Notcurses): int =
  nc.nc.notcurses_render().int

proc stop*(nc: Notcurses): int =
  nc.nc.notcurses_stop().int
