import std/tempfiles
import pkg/unittest2
import notcurses/abi

suite "ABI tests":
  setup:
    let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT or NCOPTION_SUPPRESS_BANNERS
    var
      (tmpf, tmpp) = createTempFile("", "")
      opts = notcurses_options(flags: flags)
    let nc = notcurses_init(addr opts, tmpf)
    if nc.isNil: raise (ref Defect)(msg: "Notcurses failed to initialize")

    echo "tmpf path: " & tmpp

  teardown:
    let code = notcurses_stop nc
    if code < 0: raise (ref Defect)(msg: "Notcurses failed to stop")
    tmpf.close

  test "test 1":
    check: true

  test "test 2":
    check: true
