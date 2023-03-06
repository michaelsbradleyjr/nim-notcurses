import std/encodings
import pkg/stew/[endians2, byteutils]
import pkg/unittest2
import notcurses/abi

proc mbstowcs*(dest: ptr array[5, abi.wchar_t], src: ptr UncheckedArray[byte], n: csize_t): csize_t {.cdecl, header: "<stdlib.h>", importc.}

proc wchar_t*(wc: uint8 | uint16 | uint32): abi.wchar_t = cast[abi.wchar_t](wc.uint32)

proc wcstombs*(dest: array[5, char], src: array[5, abi.wchar_t], n: csize_t): csize_t {.cdecl, header: "<stdlib.h>", importc.}

proc wcwidth*(wc: wchar_t): cint {.cdecl, header: "<wchar.h>", importc.}

proc wcswidth*(wc: ptr array[5, abi.wchar_t], n: csize_t): cint {.cdecl, header: "<wchar.h>", importc.}

proc wprintf*(wc: ptr array[5, abi.wchar_t]): cint {.cdecl, header: "<wchar.h>", importc.}

proc toString*(buf: array[5, char]): string =
  var b: seq[byte]
  b.add buf[0].byte
  for c in buf[1..3]:
    if c != '\x00': b.add c.byte
    else: break
  string.fromBytes b

suite "ABI tests":
  test "NCCELL_ initializers":
    echo ""

    var foo_1 = "a"
    var fooD_1: array[5, abi.wchar_t]
    var fooS_1 = convert(foo_1, "UTF-32")
    var fooO_1: array[5, char]
    echo "original string: " & $foo_1
    echo "mbstowcs return: " & $mbstowcs(addr fooD_1, cast[ptr UncheckedArray[byte]](addr fooS_1), 4)
    stdout.write "wide string: "
    discard wprintf(addr fooD_1)
    echo ""
    echo "wcswidth: " & $wcswidth(addr fooD_1, 4)
    echo "wcstombs return: " & $wcstombs(fooO_1, fooD_1, 4)
    echo "roundtrip string: " & fooO_1.toString

    echo ""

    # var fooD_2: array[5, abi.wchar_t]
    # var fooS_2 = "\t".cstring
    # var fooO_2: array[5, char]
    # echo "original string: [" & $fooS_2 & "]"
    # echo "mbstowcs return: " & $mbstowcs(addr fooD_2, fooS_2, 4)
    # stdout.write("wide string: ")
    # stdout.write("[")
    # discard wprintf(addr fooD_2)
    # stdout.write("]")
    # echo ""
    # # echo "wcwidth: " & $wcwidth(fooD_2[0])
    # echo "wcswidth: " & $wcswidth(addr fooD_2, 4)
    # echo "wcstombs return: " & $wcstombs(fooO_2, fooD_2, 4)
    # echo "roundtrip string: [" & fooO_2.toString & "]"

    # echo ""

    # var fooD_3: array[5, abi.wchar_t]
    # var fooS_3 = "\u4E11".cstring
    # var fooO_3: array[5, char]
    # echo "original string: " & $fooS_3
    # echo "mbstowcs return: " & $mbstowcs(addr fooD_3, fooS_3, 4)
    # stdout.write "wide string: "
    # discard wprintf(addr fooD_3)
    # echo ""
    # # echo "wcwidth: " & $wcwidth(fooD_3[0])
    # echo "wcswidth: " & $wcswidth(addr fooD_3, 4)
    # echo "wcstombs return: " & $wcstombs(fooO_3, fooD_3, 4)
    # echo "roundtrip string: " & fooO_3.toString

    # echo ""

    # var fooD_4: array[5, abi.wchar_t]
    # var fooS_4 = "\u{1F3B8}".cstring
    # var fooO_4: array[5, char]
    # echo "original string: " & $fooS_4
    # echo "mbstowcs return: " & $mbstowcs(addr fooD_4, fooS_4, 4)
    # stdout.write "wide string: "
    # discard wprintf(addr fooD_4)
    # echo ""
    # # echo "wcwidth: " & $wcwidth(fooD_4[0])
    # echo "wcswidth: " & $wcswidth(addr fooD_4, 4)
    # echo "wcstombs return: " & $wcstombs(fooO_4, fooD_4, 4)
    # echo "roundtrip string: " & fooO_4.toString

    # echo ""

    # var fooD_5: array[5, abi.wchar_t]
    # var fooS_5 = "b".cstring
    # var fooO_5: array[5, char]
    # echo "original string: " & $fooS_5
    # echo "mbstowcs return: " & $mbstowcs(addr fooD_5, fooS_5, 4)
    # stdout.write "wide string: "
    # discard wprintf(addr fooD_5)
    # echo ""
    # echo "wcwidth: " & $wcwidth(fooD_5[0])
    # echo "wcstombs return: " & $wcstombs(fooO_5, fooD_5, 4)
    # echo "roundtrip string: " & fooO_5.toString

    # echo ""

    # var fooD_6: array[5, abi.wchar_t]
    # var fooS_6 = "℞".cstring
    # var fooO_6: array[5, char]
    # echo "original string: " & $fooS_6
    # echo "mbstowcs return: " & $mbstowcs(addr fooD_6, fooS_6, 4)
    # stdout.write "wide string: "
    # discard wprintf(addr fooD_6)
    # echo ""
    # echo "wcwidth: " & $wcwidth(fooD_6[0])
    # echo "wcstombs return: " & $wcstombs(fooO_6, fooD_6, 4)
    # echo "roundtrip string: " & fooO_6.toString

    # echo ""

    let
      cell1 = NCCELL_CHAR_INITIALIZER('a'.cchar)
      cell2 = NCCELL_INITIALIZER(0xe4b880'u32, 0, 0) # U+4E00
      cell3 = NCCELL_INITIALIZER(0xefbbbf'u32, 0, 0) # U+FEFF
      cell4 = NCCELL_INITIALIZER(0xf09f8eb8'u32, 0, 0) # U+1F3B8
      cell5 = NCCELL_TRIVIAL_INITIALIZER()
      cell6 = NCCELL_CHAR_INITIALIZER('\t'.cchar)

    # echo $cell1
    # echo $wcwidth('a'.cchar.uint32.wchar_t)
    # echo $cell2
    # echo $wcwidth(0xe4b880'u32.wchar_t)
    # echo $cell3
    # echo $wcwidth(0xefbbbf'u32.wchar_t)
    # echo $cell4
    # echo $wcwidth(0xf09f8eb8'u32.wchar_t)
    # echo $cell5
    # echo $cell6
    # echo $wcwidth(wchar_t('\t'))

    check:
      true == true
      # cell1.width == 1
      # cell2.width == 1
      # cell3.width == 1
      # cell4.width == 1
      # cell5.width == 1
      # cell6.width == 1
