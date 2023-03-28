import pkg/unittest2
import notcurses/abi

when not defined(windows):
  suite "ABI tests":
    setup:
      let flags = NCOPTION_CLI_MODE or NCOPTION_DRAIN_INPUT or NCOPTION_SUPPRESS_BANNERS
      var opts = notcurses_options(flags: flags)
      let nc = notcurses_init(addr opts, stdout)
      if nc.isNil: raise (ref Defect)(msg: "Notcurses failed to initialize")

    teardown:
      let code = notcurses_stop nc
      if code < 0: raise (ref Defect)(msg: "Notcurses failed to stop")
      discard

    test "test 1":
      check: true

    test "test 2":
      check: true

func `==`(x, y: Wchar): bool = x.uint32 == y.uint32

suite "ABI tests (no init)":
  test "compare wide strings":
    # for i in 0..(NCBOXLIGHTW_a.len - 1):
    #   check:
    #     NCBOXLIGHTW_a[i].uint32 == NCBOXLIGHTW[][i].uint32

    echo ""
    echo sizeof(Wchar)
    echo ""
    var i = 0
    while true:
      when defined(windows):
        let wc = NCBOXLIGHTW[][i].uint16
      else:
        let wc = NCBOXLIGHTW[][i].uint32
      echo wc
      if wc == 0: break
      inc i
    echo ""
    echo i + 1
    echo ""

    check: true
