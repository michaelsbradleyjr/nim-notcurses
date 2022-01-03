export
  Notcurses,
  NotcursesDefect,
  NotcursesDefectMessages,
  NotcursesError,
  NotcursesErrorMessages,
  NotcursesInitOption,
  NotcursesInitOptions,
  NotcursesInput,
  NotcursesInputEvent,
  NotcursesInputEvents,
  NotcursesOptions,
  NotcursesPlane,
  addNotcursesExitProc,
  codepoint,
  event,
  expect,
  get,
  getBlocking,
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
  NcInputEvent* = NotcursesInputEvent
  NcInputEvents* = NotcursesInputEvent
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
  eventType* = event
  evType* = event
  id* = codepoint
  putString* = putStr
  stopNc* = stopNotcurses

template addNcExitProc*() = addNotcursesExitProc()
