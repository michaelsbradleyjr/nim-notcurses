# L[num] comments below pertain to sources for Notcurses v3.0.9
# https://github.com/dankamongmen/notcurses/tree/v3.0.9/include

when (NimMajor, NimMinor) >= (1, 4):
  {.push raises: [].}
else:
  {.push raises: [Defect].}

import std/[strutils, terminal]
import ./constants
import ./wide

export wide except toSeqB, toSeqW

type AbiDefect = object of Defect

# L187 notcurses/nckeys.h
func nckey_synthesized_p*(w: uint32): bool =
  (w >= PRETERUNICODEBASE) and (w <= NCKEY_EOF)

# L201 notcurses/nckeys.h
func nckey_pua_p*(w: uint32): bool =
  (w >= 0x0000e000'u32) and (w <= 0x0000f8ff'u32)

# L207 notcurses/nckeys.h
func nckey_supppuaa_p*(w: uint32): bool =
  (w >= 0x000f0000'u32) and (w <= 0x000ffffd'u32)

# L213 notcurses/nckeys.h
func nckey_supppuab_p*(w: uint32): bool =
  (w >= 0x00100000'u32) and (w <= 0x0010fffd'u32)

const nc_header = "notcurses/notcurses.h"
{.pragma: nc, cdecl, header: nc_header, importc.}

# L39 - notcurses/notcurses.h
proc notcurses_version*(): cstring {.nc.}

# L42 - notcurses/notcurses.h
proc notcurses_version_components*(major, minor, patch, tweak: ptr cint) {.nc.}

var
  lib_notcurses_major*: cint
  lib_notcurses_minor*: cint
  lib_notcurses_patch*: cint
  lib_notcurses_tweak*: cint

notcurses_version_components(addr lib_notcurses_major, addr lib_notcurses_minor, addr lib_notcurses_patch, addr lib_notcurses_tweak)

if nim_notcurses_version.major != lib_notcurses_major:
  let majorMismatchMsg = ("""
nim-notcurses major version $1 is not compatible with Notcurses library major
version $4 (nim-notcurses: $1.$2.$3, libnotcurses: $5)
  """ % [
    $nim_notcurses_version.major,
    $nim_notcurses_version.minor,
    $nim_notcurses_version.patch,
    $lib_notcurses_major,
    $notcurses_version()
  ]).strip.replace("\n", " ")
  styledWriteLine(stderr, fgRed, "Error: ", resetStyle, majorMismatchMsg)
  raise (ref AbiDefect)(msg: "libnotcurses major version mismatch")

const ncWarnMinor {.booldefine.}: bool = true

when ncWarnMinor:
  if (nim_notcurses_version.major, nim_notcurses_version.minor) >
      (lib_notcurses_major, lib_notcurses_minor):
    let minorMismatchMsg = ("""
nim-notcurses minor version $1.$2 is newer than Notcurses library minor
version $4.$5 (nim-notcurses: $1.$2.$3, libnotcurses: $6)
    """ % [
      $nim_notcurses_version.major,
      $nim_notcurses_version.minor,
      $nim_notcurses_version.patch,
      $lib_notcurses_major,
      $lib_notcurses_minor,
      $notcurses_version()
    ]).strip.replace("\n", " ")
    styledWriteLine(stderr, fgYellow, "Warning: ", resetStyle, minorMismatchMsg)
