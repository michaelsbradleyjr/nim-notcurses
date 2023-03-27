import pkg/unittest2
import notcurses/abi

suite "ABI tests":
  setup:
    let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT or NCOPTION_SUPPRESS_BANNERS
    var
      devNull = open("/dev/null", fmReadWrite)
      opts = notcurses_options(flags: flags)
    let nc = notcurses_init(addr opts, devNull)
    if nc.isNil: raise (ref Defect)(msg: "Notcurses failed to initialize")

  teardown:
    let code = notcurses_stop nc
    if code < 0: raise (ref Defect)(msg: "Notcurses failed to stop")
    devNull.close

  test "test 1":
    check: true

  test "test 2":
    check: true
