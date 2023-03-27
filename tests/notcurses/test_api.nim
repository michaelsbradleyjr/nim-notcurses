import pkg/unittest2
import notcurses

suite "API tests":
  setup:
    var devNull = open("/dev/null", fmReadWrite)
    let
      opts = [CliMode, DrainInput, SuppressBanners]
      nc = Nc.init(NcOptions.init opts, devNull, false)

  teardown:
    nc.stop
    devNull.close

  test "test 1":
    check: true

  test "test 2":
    check: true
