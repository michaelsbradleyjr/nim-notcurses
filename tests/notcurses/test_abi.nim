import pkg/unittest2
import notcurses/abi

suite "ABI tests":
  test "foo":

    let
      cell1 = NCCELL_INITIALIZER(0xefbbbf'u32, 0, 0)
      cell2 = NCCELL_CHAR_INITIALIZER('a'.cchar)
      cell3 = NCCELL_INITIALIZER(0x4e00'u32, 0, 0)
      cell4 = NCCELL_TRIVIAL_INITIALIZER()

    echo ""
    echo $cell1
    echo $cell2
    echo $cell3
    echo $cell4
    echo ""

    check:
      cell1.width == 1
      cell2.width == 1
      cell3.width == 2
      cell4.width == 1
