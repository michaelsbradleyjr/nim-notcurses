import pkg/unittest2
import notcurses/abi

suite "ABI tests":
  test "foo":
    check: 1 + 1 == 2
