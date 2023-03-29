import std/macros
import pkg/unittest2
import notcurses/abi
import ./ncseqs

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

when defined(windows):
  func `==`(x, y: Wchar): bool = x.uint16 == y.uint16
else:
  func `==`(x, y: Wchar): bool = x.uint32 == y.uint32

suite "ABI tests (no init)":
  test "compare wide strings from notcurses/ncseqs.h":
    macro compare(was: seq[string]): untyped =
      # debugEcho treeRepr(was)
      result = newStmtList()
      for slit in was[1]:
        # debugEcho ident(strVal(slit))
        let wa = ident(strVal(slit))
        # debugEcho ident(strVal(slit) & "_impc")
        let wa_impc = ident(strVal(slit) & "_impc")
        result.add quote do:
          echo ""
          for wc in `wa`:
            when defined(windows):
              echo wc.uint16
            else:
              echo wc.uint32
          echo ""
          echo `wa`.len
          echo ""
          var i = 0
          while true:
            when defined(windows):
              let wc = `wa_impc`[][i].uint16
            else:
              let wc = `wa_impc`[][i].uint32
            echo wc
            if wc == 0: break
            inc i
          echo ""
          echo i + 1
          for j in 0..(`wa`.len - 1):
            check:
              when defined(windows):
                `wa`[j].uint16 == `wa_impc`[][j].uint16
              else:
                `wa`[j].uint32 == `wa_impc`[][j].uint32
      # debugEcho toStrLit(result)

    compare @[
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
