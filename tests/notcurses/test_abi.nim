import std/macros
import pkg/unittest2
import notcurses/abi

when not defined(windows):
  suite "ABI tests":
    setup:
      let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT or NCOPTION_SUPPRESS_BANNERS
      var opts = notcurses_options(flags: flags)
      let nc = notcurses_init(addr opts, stdout)
      if nc.isNil: raise (ref Defect)(msg: "Notcurses failed to initialize")

    teardown:
      let code = notcurses_stop nc
      if code < 0: raise (ref Defect)(msg: "Notcurses failed to stop")
      discard

    test "test 1":
      check: true

    test "test 2":
      check: true

# write brief explanation re: what's being importc'd and comparison-tested below

const ncseqsNames = [
  "NCBOXLIGHTW",
  "NCBOXHEAVYW",
  "NCBOXROUNDW",
  "NCBOXDOUBLEW",
  "NCBOXASCIIW",
  "NCBOXOUTERW",
  "NCWHITESQUARESW",
  "NCWHITECIRCLESW",
  "NCCIRCULARARCSW",
  "NCWHITETRIANGLESW",
  "NCBLACKTRIANGLESW",
  "NCSHADETRIANGLESW",
  "NCBLACKARROWHEADSW",
  "NCLIGHTARROWHEADSW",
  "NCARROWDOUBLEW",
  "NCARROWDASHEDW",
  "NCARROWCIRCLEDW",
  "NCARROWANTICLOCKW",
  "NCBOXDRAWW",
  "NCBOXDRAWHEAVYW",
  "NCARROWW",
  "NCDIAGONALSW",
  "NCDIGITSSUPERW",
  "NCDIGITSSUBW",
  "NCASTERISKS5",
  "NCASTERISKS6",
  "NCASTERISKS8",
  "NCANGLESBR",
  "NCANGLESTR",
  "NCANGLESBL",
  "NCANGLESTL",
  "NCEIGHTHSB",
  "NCEIGHTHST",
  "NCEIGHTHSL",
  "NCEIGHTHSR",
  "NCHALFBLOCKS",
  "NCQUADBLOCKS",
  "NCSEXBLOCKS",
  "NCBRAILLEEGCS",
  "NCSEGDIGITS",
  "NCSUITSBLACK",
  "NCSUITSWHITE",
  "NCCHESSBLACK",
  "NCCHESSWHITE",
  "NCDICE",
  "NCMUSICSYM"
]

macro mkImpc(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let
      cname = ident(name)
      impc_aw = ident(name & "_impc_aw")
      impc_puaw = ident(name & "_impc_puaw")
    result.add quote do:
      # can be `let` instead of `var` with recent enough releases of Nim 1.4+
      var `impc_aw` {.header: "notcurses/ncseqs.h", importc: `name`, nodecl.}: array[`cname`.len, Wchar]
      var `impc_puaw` {.header: "notcurses/ncseqs.h", importc: `name`, nodecl.}: ptr UncheckedArray[Wchar]
  # debugEcho toStrLit(result)

mkImpc ncseqsNames

proc `$`(wc: Wchar): string {.borrow.}
proc `==`(x, y: Wchar): bool {.borrow.}

macro compare(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let wa = ident name
    let wa_impc_aw = ident(name & "_impc_aw")
    let wa_impc_puaw = ident(name & "_impc_puaw")
    result.add quote do:
      echo ""
      echo `name`
      echo ""
      for wc in `wa`:
        echo wc
      echo ""
      echo `wa`.len
      echo ""
      echo `name` & "_impc_aw"
      echo ""
      for wc in `wa_impc_aw`:
        echo wc
      echo ""
      echo `wa_impc_aw`.len
      echo ""
      echo `name` & "_impc_puaw"
      echo ""
      var i = 0
      while true:
        let wc = `wa_impc_puaw`[][i]
        echo wc
        if wc == 0.wchar: break
        inc i
      echo ""
      echo i + 1
      for j in 0..(`wa`.len - 1):
        check:
          `wa`.len == i + 1
          `wa`[j] == `wa_impc_aw`[j]
          `wa`[j] == `wa_impc_puaw`[][j]
  # debugEcho toStrLit(result)

suite "ABI tests (no init)":
  test "compare wide strings from notcurses/ncseqs.h":
    compare ncseqsNames
