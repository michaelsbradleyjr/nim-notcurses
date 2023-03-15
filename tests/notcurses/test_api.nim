import pkg/unittest2
import notcurses/cli

suite "API tests":
  setup:
    let
      opts = [DrainInput, SuppressBanners]
      nc = Nc.init(NcOptions.init opts, addExitProc = false)
      stdn = nc.stdPlane

  teardown:
    nc.stop

  test "test 1":
    check: true

  test "test 2":
    check: true
