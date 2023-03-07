import std/[macros, typetraits]
import pkg/unittest2
import notcurses/abi

proc fputws(str: ptr UncheckedArray[ptr wchar_t], stream: File): cint {.cdecl, header: "<stdio.h>", importc.}

proc mbstowcs(dst: ptr UncheckedArray[ptr wchar_t], src: cstring, len: csize_t): csize_t {.cdecl, header: "<stdlib.h>", importc.}

suite "ABI tests":
  test "NCCELL_ initializers":
    # let
    #   cell1 = NCCELL_CHAR_INITIALIZER('a'.cchar)
    #   cell2 = NCCELL_INITIALIZER(0xe4b880'u32, 0, 0) # U+4E00
    #   cell3 = NCCELL_INITIALIZER(0xefbbbf'u32, 0, 0) # U+FEFF
    #   cell4 = NCCELL_INITIALIZER(0xf09f8eb8'u32, 0, 0) # U+1F3B8
    #   cell5 = NCCELL_TRIVIAL_INITIALIZER()
    #   cell6 = NCCELL_CHAR_INITIALIZER('\t'.cchar)
    #
    # echo ""
    #
    # echo $cell1
    # echo $cell2
    # echo $cell3
    # echo $cell4
    # echo $cell5
    # echo $cell6

    echo ""

    echo "trying my impl of L"
    echo ""

    proc L[T](ws: static[T]): seq[ptr wchar_t] =
      var mbs = ws.cstring
      var wca: array[ws.len, ptr wchar_t]
      discard mbstowcs(cast[ptr UncheckedArray[ptr wchar_t]](addr wca), mbs, ws.len)
      var wcs: seq[ptr wchar_t]
      for p in wca:
        if not p.isNil: wcs.add p
        else: break
      wcs

    let xyz = L"this is printed to stdout by fputws 🎸"

    var wca_out: array[40, ptr wchar_t]
    for i, p in xyz.pairs:
      wca_out[i] = p

    discard fputws(cast[ptr UncheckedArray[ptr wchar_t]](addr wca_out), stdout)
    echo ""

    echo ""

    check:
      true == true

      # cell1.width == 1
      # cell2.width == 1
      # cell3.width == 1
      # cell4.width == 1
      # cell5.width == 1
      # cell6.width == 1
