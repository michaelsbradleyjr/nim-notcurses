import std/macros
import pkg/notcurses/abi
import pkg/notcurses/abi/direct
import pkg/unittest2
import ./helpers/ncseqs

when not defined(windows):
  suite "ABI":
    setup:
      let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT or
        NCOPTION_SUPPRESS_BANNERS
      var opts = notcurses_options(flags: flags)
      let nc = notcurses_init(addr opts, stdout)
      if nc.isNil: raise (ref Defect)(msg: "notcurses_init failed")

    teardown:
      if notcurses_stop(nc) < 0:
        raise (ref Defect)(msg: "notcurses_stop failed")

    test "init then stop":
      check: true

    test "init then stop again":
      check: true

  suite "ABI Direct mode":
    setup:
      let
        flags = NCDIRECT_OPTION_DRAIN_INPUT
        ncd = ncdirect_init(nil, stdout, flags)
      if ncd.isNil: raise (ref Defect)(msg: "ncdirect_init failed")

    teardown:
      if ncdirect_stop(ncd) < 0: raise (ref Defect)(msg: "ncdirect_stop failed")

    test "init then stop":
      check: true

    test "init then stop again":
      check: true

# wide string literals in notcurses/notcurses.h are defined in abi/wide.nim as
# Nim `const` via `macro L` that calculates at compile-time arrays of wchar_t
# (type Wchar); it's also possible to access those wide strings via importc
# (two possibilities: as normal array of known length, or as ptr UncheckedArray)

# to ensure that `macro L` is implemented correctly, a test is provided below
# that compares arrays generated with `macro L` and those accessed via importc

macro mkImpc(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  result.add quote do:
    {.pragma: nc_seqs, header: "notcurses/ncseqs.h", nodecl.}
  for name in names:
    let
      const_id = ident name
      impc_aw = ident(name & "_impc_aw")
      impc_puaw = ident(name & "_impc_puaw")
    result.add quote do:
      # can be `let` instead of `var` with recent enough releases of Nim 1.4+
      var
        `impc_aw` {.nc_seqs, importc: `name`.}: array[`const_id`.len, Wchar]
        `impc_puaw` {.nc_seqs, importc: `name`.}: ptr UncheckedArray[Wchar]
  # debugEcho toStrLit(result)

mkImpc ncWideStringsNames

macro compareW(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let
      const_id = ident name
      impc_aw = ident(name & "_impc_aw")
      impc_puaw = ident(name & "_impc_puaw")
    result.add quote do:
      var i = 0
      while true:
        let wc = `impc_puaw`[][i]
        if wc == 0.wchar: break
        inc i
      check: i + 1 == `const_id`.len
      for j in 0..<`const_id`.len:
        check:
          `impc_aw`[j] == `const_id`[j]
          `impc_puaw`[][j] == `const_id`[j]
  # debugEcho toStrLit(result)

suite "ABI (no init)":
  test "compare importc'd wide strings with constants":
    compareW ncWideStringsNames

suite "ABI Direct mode (no init)":
  test "should write some tests":
    check: true
