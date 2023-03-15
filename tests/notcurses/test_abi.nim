import pkg/unittest2
import notcurses/abi

suite "ABI tests":
  setup:
    let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT or
      NCOPTION_SUPPRESS_BANNERS
    var
      opts = notcurses_options(termtype: nil, loglevel: NCLOGLEVEL_PANIC,
        margin_t: 0, margin_r: 0, margin_b: 0, margin_l: 0, flags: flags)
    let nc = notcurses_init(addr opts, stdout)
    if nc.isNil: raise (ref Defect)(msg: "Notcurses failed to initialize")
    let stdn = notcurses_stdplane(nc)

  teardown:
    let code = notcurses_stop(nc)
    if code < 0: raise (ref Defect)(msg: "Notcurses failed to stop")

  test "test 1":
    check: true

  test "test 2":
    check: true
