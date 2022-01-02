export
  Notcurses,
  NotcursesDefect,
  NotcursesDefectMessages,
  NotcursesError,
  NotcursesErrorMessages,
  NotcursesInitOption,
  NotcursesInitOptions,
  NotcursesInput,
  NotcursesOptions,
  NotcursesPlane,
  evType,
  expect,
  get,
  getBlocking,
  id,
  init,
  putStr,
  render,
  results,
  setScrolling,
  stdPlane,
  stop,
  stopNotcurses

# Friendly aliases, limit to intuitive shortenings:
type
  Nc* = Notcurses
  NcDefect* = NotcursesDefect
  NcErr* = NotcursesError
  NcError* = NotcursesError
  NcInitOpt* = NotcursesInitOption
  NcInitOpts* = NotcursesInitOptions
  NcInitOption* = NotcursesInitOption
  NcInitOptions* = NotcursesInitOptions
  NcInput* = NotcursesInput
  NcOpt* = NotcursesInitOption
  NcOpts* = NotcursesOptions
  NcOption* = NotcursesInitOption
  NcOptions* = NotcursesOptions
  NcPlane* = NotcursesPlane
  NcSuc* = NotcursesSuccess
  NcSucc* = NotcursesSuccess
  NcSuccess* = NotcursesSuccess
  ncoption* = NotcursesInitOption

const
  putString* = putStr
  stopNc* = stopNotcurses
