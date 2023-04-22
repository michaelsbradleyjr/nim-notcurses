# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include

when (NimMajor, NimMinor, NimPatch) >= (1, 4, 0):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import ../common
import ./constants

export common except lib_notcurses_major, lib_notcurses_minor, lib_notcurses_patch, lib_notcurses_tweak
export constants except PRETERUNICODEBASE, nim_notcurses_version

const
  nc_header = "notcurses/notcurses.h"
  ncd_header = "notcurses/direct.h"

{.pragma: nc_incomplete, header: nc_header, incompleteStruct.}
{.pragma: ncd, cdecl, header: ncd_header, importc.}

# L60 - notcurses/notcurses.h
type ncdirect* {.nc_incomplete, importc: "struct ncdirect".} = object

# L59 - notcurses/direct.h
proc ncdirect_init*(termtype: cstring, fp: File, flags: uint64): ptr ncdirect {.ncd.}

# L63 - notcurses/direct.h
proc ncdirect_core_init*(termtype: cstring, fp: File, flags: uint64): ptr ncdirect {.ncd.}

# L92 - notcurses/direct.h
proc ncdirect_putstr*(nc: ptr ncdirect, channels: uint64, utf8: cstring): cint {.ncd.}

# L142 - notcurses/direct.h
proc ncdirect_supported_styles*(nc: ptr ncdirect): uint16 {.ncd.}

# L146 - notcurses/direct.h
proc ncdirect_set_styles*(n: ptr ncdirect, stylebits: cuint): cint {.ncd.}

# L279 - notcurses/direct.h
proc ncdirect_stop*(nc: ptr ncdirect): cint {.ncd.}
