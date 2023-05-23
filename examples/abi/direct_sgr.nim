import std/[bitops, strutils]
import pkg/notcurses/abi/direct/core
# or: import pkg/notcurses/abi/direct

let flags = NCDIRECT_OPTION_DRAIN_INPUT

let ncd = ncdirect_core_init(nil, stdout, flags)
if ncd.isNil: raise (ref Defect)(msg: "ncdirect_core_init failed")

# or: let ncd = ncdirect_init(nil, stdout, flags)
# or: if ncd.isNil: raise (ref Defect)(msg: "ncdirect_init failed")

let supportedStyles = ncdirect_supported_styles(ncd).uint32

var e, i = 0'u32
while i < (NCSTYLE_ITALIC shl 1):
  let styles = bitand(supportedStyles, i)
  discard ncdirect_set_styles(ncd, styles)
  discard ncdirect_putstr(ncd, 0, (i.uint64.toHex(8).toLower & " ").cstring)
  discard ncdirect_set_styles(ncd, NCSTYLE_NONE)
  inc e
  if e mod 8 == 0: discard ncdirect_putstr(ncd, 0, "\n")
  inc i

if ncdirect_stop(ncd) < 0: raise (ref Defect)(msg: "ncdirect_stop failed")
