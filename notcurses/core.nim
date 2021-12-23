# Eventually this module should export a high/er-level "Nim oriented" API.
# For now it's a thin wrapper around the "plain vanilla" wrapper around
# Notcurses C API... and some niceties in the direction of a high/er-level API.

# consider how to eliminate duplication in notcurses.nim and notcurses/core.nim

import std/bitops

import ./wrapper/core

export core

type
  Ncoption* = culonglong
  Notcurses* = notcurses
  Options* = notcurses_options

var initd = false

func init*(T: typedesc[Options], options: varargs[Ncoption]): Options =
  var opts: Ncoption
  if options.len == 0:
    opts = 0
  elif options.len == 1:
    opts = options[0]
  else:
    opts = options[0]
    for o in options[1..^1]:
      opts = bitor(opts, o)
  Options(flags: opts)

proc init*(T: typedesc[Notcurses], opts: Options, file: File = stdout):
  ptr type T =

  if initd: raise newException(Defect, "Notcurses is already initialized!")
  let nc = notcurses_init(unsafeAddr opts, file)
  if isNil(nc): raise newException(Defect, "Notcurses failed to initialize!")
  initd = true
  nc
