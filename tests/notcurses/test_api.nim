import std/tempfiles
import pkg/unittest2
import notcurses

suite "API tests":
  setup:
    var (tmpf, tmpp) = createTempFile("", "")
    let
      opts = [CliMode, DrainInput, SuppressBanners]
      nc = Nc.init(NcOptions.init opts, tmpf, false)

    echo "tmpf path: " & tmpp

  teardown:
    nc.stop
    tmpf.close

  test "test 1":
    check: true

  test "test 2":
    check: true
