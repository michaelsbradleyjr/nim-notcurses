import std/macros
import pkg/unittest2
import notcurses
import notcurses/abi/constants/ncseqs
import ./helpers/ncseqs as helpers_ncseqs

when not defined(windows):
  suite "API tests":
    setup:
      let
        opts = [InitOptions.CliMode, InitOptions.DrainInput, InitOptions.SuppressBanners]
        nc = Nc.init(NcOptions.init opts, addExitProc = false)

    teardown:
      nc.stop

    test "test 1":
      check: true

    test "test 2":
      check: true

# to ensure that `string.fromWide` and `[string].toWide` are implemented
# correctly, tests are provided below that compare wide strings converted to
# Nim strings with the string literals they should match, and then converts
# those Nim strings back to wide strings to compare them with the originals

macro compareN(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let
      wa = ident name
      ns = ident(name & "_ns")
    result.add quote do:
      check: string.fromWide(`wa`) == `ns`
  # debugEcho toStrLit(result)

suite "API tests (no init)":
  test "compare wide strings converted to Nim strings with string literals":
    compareN ncWideSeqsNames
    check:
      $NCBOXLIGHT == NCBOXLIGHT_ns
      $NCBOXHEAVY == NCBOXHEAVY_ns
      $NCBOXROUND == NCBOXROUND_ns
      $NCBOXDOUBLE == NCBOXDOUBLE_ns
      $NCBOXASCII == NCBOXASCII_ns
      $NCBOXOUTER == NCBOXOUTER_ns

  # impl me, after impl'ing `[string].toWide`
  # test "compare Nim strings converted to wide strings with constants":
  #   compareToW ncWideSeqsNames
  #   check:
  #     NCBOXLIGHT == NCBOXLIGHT_ns.cstring
  #     NCBOXHEAVY == NCBOXHEAVY_ns.cstring
  #     NCBOXROUND == NCBOXROUND_ns.cstring
  #     NCBOXDOUBLE == NCBOXDOUBLE_ns.cstring
  #     NCBOXASCII == NCBOXASCII_ns.cstring
  #     NCBOXOUTER == NCBOXOUTER_ns.cstring
