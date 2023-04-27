import std/macros
import pkg/unittest2
import notcurses/abi
import notcurses/abi/direct
import ./helpers/ncseqs

when not defined(windows):
  suite "ABI":
    setup:
      let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT or NCOPTION_SUPPRESS_BANNERS
      var opts = notcurses_options(flags: flags)
      let nc = notcurses_init(addr opts, stdout)
      if isNil nc: raise (ref Defect)(msg: "Notcurses failed to initialize")

    teardown:
      if notcurses_stop(nc) < 0: raise (ref Defect)(msg: "Notcurses failed to stop")

    test "init then stop":
      check: true

    test "init then stop again":
      check: true

  suite "ABI Direct mode":
    setup:
      let
        flags = NCDIRECT_OPTION_DRAIN_INPUT
        ncd = ncdirect_init(nil, stdout, flags)
      if isNil ncd: raise (ref Defect)(msg: "Direct mode failed to initialize")

    teardown:
      if ncdirect_stop(ncd) < 0: raise (ref Defect)(msg: "Direct mode failed to stop")

    test "init then stop":
      check: true

    test "init then stop again":
      check: true

# wide string literals in notcurses/notcurses.h are defined in abi/wide.nim as
# Nim `const` via `macro L` that calculates at compile-time arrays of wchar_t
# (type Wchar); it's also possible to access those wide strings via importc
# (two possibilities: as normal arrays of known length, or as ptr
# UncheckedArray)

# to ensure that `macro L` is implemented correctly, a test is provided below
# that compares arrays generated with `macro L` and those accessed via importc

macro mkImpc(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let
      cname = ident name
      impc_aw = ident(name & "_impc_aw")
      impc_puaw = ident(name & "_impc_puaw")
    result.add quote do:
      {.pragma: nc_seqs, header: "notcurses/ncseqs.h", nodecl.}
      # can be `let` instead of `var` with recent enough releases of Nim 1.4+
      var
        `impc_aw` {.nc_seqs, importc: `name`.}: array[`cname`.len, Wchar]
        `impc_puaw` {.nc_seqs, importc: `name`.}: ptr UncheckedArray[Wchar]
  # debugEcho toStrLit(result)

mkImpc ncWideSeqsNames

macro compareW(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let
      wa = ident name
      wa_impc_aw = ident(name & "_impc_aw")
      wa_impc_puaw = ident(name & "_impc_puaw")
    result.add quote do:
      var i = 0
      while true:
        let wc = `wa_impc_puaw`[][i]
        if wc == 0.wchar: break
        inc i
      check: i + 1 == `wa`.len
      for j in 0..<`wa`.len:
        check:
          `wa_impc_aw`[j] == `wa`[j]
          `wa_impc_puaw`[][j] == `wa`[j]
  # debugEcho toStrLit(result)

suite "ABI (no init)":
  test "compare importc'd wide strings with constants":
    compareW ncWideSeqsNames

suite "ABI Direct mode (no init)":
  test "should write some tests":
    check: true
