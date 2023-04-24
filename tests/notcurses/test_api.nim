import std/macros
import pkg/unittest2
import notcurses
import notcurses/abi/constants
import ./helpers/ncseqs

when not defined(windows):
  suite "API tests":
    setup:
      let
        opts = [InitOptions.CliMode, InitOptions.DrainInput, InitOptions.SuppressBanners]
        nc = Nc.init(NcOptions.init opts, addExitProc = false)

    teardown:
      nc.stop

    test "init then stop":
      check: true

    test "init then stop again":
      check: true

# to ensure that `string.fromWide` and `[string].toWide` are implemented
# correctly, tests are provided below that compare wide strings converted to
# Nim strings with Nim string literals they should match, and then converts
# those Nim strings back to wide strings to compare them with the originals

macro compareN(names: static openArray[string]): untyped =
  # debugEcho names
  result = newStmtList()
  for name in names:
    let
      wa = ident name
      ns = ident(name & "_ns")
    result.add quote do:
      let ns1 = string.fromWide `wa`
      check: ns1 == `ns`
      var wcs: seq[Wchar]
      let ws = ns1.toWide(wcs)
      var i = 0
      while true:
        let wc = ws[][i]
        if wc == 0.wchar: break
        inc i
      check: i + 1 == `wa`.len
      for j in 0..<`wa`.len:
        check:
          wcs[j] == `wa`[j]
          ws[][j] == `wa`[j]
      let
        ns2 = string.fromWide wcs
        ns3 = string.fromWide ws
      check:
        ns2 == `ns`
        ns3 == `ns`
  # debugEcho toStrLit(result)

suite "API tests (no init)":
  test "compare constants converted to Nim strings <-> wide strings with statics and originals":
    compareN ncWideSeqsNames
    for cs in [NCBOXLIGHT, NCBOXHEAVY, NCBOXROUND, NCBOXDOUBLE, NCBOXASCII, NCBOXOUTER]:
      var wcs: seq[Wchar]
      let ws = ($cs).toWide(wcs)
      let
        ns1 = string.fromWide wcs
        ns2 = string.fromWide ws
      check:
        ns1.cstring == cs
        ns2.cstring == cs
