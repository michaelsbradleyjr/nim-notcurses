import pkg/unittest2
import notcurses

suite "API tests":
  setup:
    let
      opts = [CliMode, DrainInput, SuppressBanners]
      nc = Nc.init(NcOptions.init opts, addExitProc = false)

  teardown:
    nc.stop

  test "test 1":
    check: true

  test "test 2":
    check: true
