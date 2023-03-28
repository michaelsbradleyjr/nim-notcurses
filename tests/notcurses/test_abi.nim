import pkg/unittest2
import notcurses/abi
import ./ncseqs

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

when defined(windows):
  func `==`(x, y: Wchar): bool = x.uint16 == y.uint16
else:
  func `==`(x, y: Wchar): bool = x.uint32 == y.uint32

suite "ABI tests (no init)":
  test "compare wide strings from notcurses/ncseqs.h":
    echo ""
    echo sizeof(Wchar)
    echo ""
    var i = 0
    while true:
      when defined(windows):
        let wc = NCBOXLIGHTW_impc[][i].uint16
      else:
        let wc = NCBOXLIGHTW_impc[][i].uint32
      echo wc
      if wc == 0: break
      inc i
    echo ""
    echo i + 1
    echo ""
    echo typeof(NCBOXLIGHTW)
    echo ""
    for wc in NCBOXLIGHTW:
      when defined(windows):
        echo wc.uint16
      else:
        echo wc.uint32
    echo ""
    echo NCBOXLIGHTW.len
    echo ""

    for j in 0..i:
      check:
        when defined(windows):
          NCBOXLIGHTW[j].uint16 == NCBOXLIGHTW_impc[][j].uint16
        else:
          NCBOXLIGHTW[j].uint32 == NCBOXLIGHTW_impc[][j].uint32
