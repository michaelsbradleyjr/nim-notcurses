import pkg/unittest2
import notcurses

when not defined(windows):
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

suite "API tests (no init)":
  test "test 3":
    check: true
