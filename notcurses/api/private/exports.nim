export
  `$`,
  LibNotcursesMajor,
  LibNotcursesMinor,
  LibNotcursesPatch,
  LibNotcursesTweak,
  LibNotcursesVersion,
  NimNotcursesMajor,
  NimNotcursesMinor,
  NimNotcursesPatch,
  Notcurses,
  NotcursesCodepoint,
  NotcursesDefect,
  NotcursesDefectMessages,
  NotcursesError,
  NotcursesError0,
  NotcursesErrorMessages,
  NotcursesErrorN,
  NotcursesInitOption,
  NotcursesInitOptions,
  NotcursesInput,
  NotcursesInputEvent,
  NotcursesInputEvents,
  NotcursesKey,
  NotcursesKeys,
  NotcursesLogLevel,
  NotcursesLogLevels,
  NotcursesOptions,
  NotcursesPlane,
  NotcursesSuccess,
  NotcursesSuccess0,
  NotcursesSuccessP,
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
  libVersion,
  libVersionString,
  options,
  putString,
  render,
  results,
  setScrolling,
  stdPlane,
  stop,
  toKey,
  toUTF8

# Friendly aliases, limit to intuitive shortenings:
type
  LibNcVersion* = LibNotcursesVersion
  Nc* = Notcurses
  NcCodepoint* = NotcursesCodepoint
  NcDefect* = NotcursesDefect
  NcErr* = NotcursesError
  NcErr0* = NotcursesError0
  NcErrN* = NotcursesErrorN
  NcError* = NotcursesError
  NcError0* = NotcursesError0
  NcErrorN* = NotcursesErrorN
  NcInitOpt* = NotcursesInitOption
  NcInitOpts* = NotcursesInitOptions
  NcInitOption* = NotcursesInitOption
  NcInitOptions* = NotcursesInitOptions
  NcInput* = NotcursesInput
  NcInputEvent* = NotcursesInputEvent
  NcInputEvents* = NotcursesInputEvent
  NcKey* = NotcursesKey
  NcKeys* = NotcursesKeys
  NcLogLevel* = NotcursesLogLevel
  NcLogLevels* = NotcursesLogLevels
  NcOpt* = NotcursesInitOption
  NcOpts* = NotcursesOptions
  NcOption* = NotcursesInitOption
  NcOptions* = NotcursesOptions
  NcPlane* = NotcursesPlane
  NcSuc* = NotcursesSuccess
  NcSuc0* = NotcursesSuccess0
  NcSucP* = NotcursesSuccessP
  NcSucc* = NotcursesSuccess
  NcSucc0* = NotcursesSuccess0
  NcSuccP* = NotcursesSuccessP
  NcSuccess* = NotcursesSuccess
  NcSuccess0* = NotcursesSuccess0
  NcSuccessP* = NotcursesSuccessP

const
  NNcMajor* = NimNotcursesMajor
  NNcMinor* = NimNotcursesMinor
  NNcPatch* = NimNotcursesPatch
  Return* = NotcursesKeys.Enter
  ScrollUp* = NotcursesKeys.Button4
  ScrollDown* = NotcursesKeys.Button5
  eventType* = event
  evType* = event
  id* = codepoint
  putStr* = putString

let
  LibNcMajor* = LibNotcursesMajor
  LibNcMinor* = LibNotcursesMinor
  LibNcPatch* = LibNotcursesPatch
  LibNcTweak* = LibNotcursesTweak
