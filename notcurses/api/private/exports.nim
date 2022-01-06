export
  `$`,
  Notcurses,
  NotcursesCodepoint,
  NotcursesDefect,
  NotcursesDefectMessages,
  NotcursesError,
  NotcursesErrorMessages,
  NotcursesInitOption,
  NotcursesInitOptions,
  NotcursesInput,
  NotcursesInputEvent,
  NotcursesInputEvents,
  NotcursesKey,
  NotcursesKeys,
  NotcursesOptions,
  NotcursesPlane,
  addExitProc,
  byteutils,
  codepoint,
  event,
  expect,
  get,
  getBlocking,
  init,
  isKey,
  isUTF8,
  options,
  putString,
  render,
  results,
  setScrolling,
  stdPlane,
  stop,
  stopNotcurses,
  toKey,
  toUTF8

# Friendly aliases, limit to intuitive shortenings:
type
  Nc* = Notcurses
  NcCodepoint* = NotcursesCodepoint
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
  NcKey* = NotcursesKey
  NcKeys* = NotcursesKeys
  NcOpt* = NotcursesInitOption
  NcOpts* = NotcursesOptions
  NcOption* = NotcursesInitOption
  NcOptions* = NotcursesOptions
  NcPlane* = NotcursesPlane
  NcSuc* = NotcursesSuccess
  NcSucc* = NotcursesSuccess
  NcSuccess* = NotcursesSuccess

const
  Return* = NotcursesKeys.Enter
  ScrollUp* = NotcursesKeys.Button4
  ScrollDown* = NotcursesKeys.Button5
  eventType* = event
  evType* = event
  id* = codepoint
  putStr* = putString
  stopNc* = stopNotcurses
