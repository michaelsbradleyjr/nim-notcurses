import # notcurses modules
  ../version

const
  ncAltNames {.strdefine.} = "libnotcurses-core"
  ncHeaderRelPath {.strdefine.} = "include/notcurses/direct.h"

include ../includes/imports
include ../includes/defines_ncdirect
include ../includes/generator_top
include ../includes/generator_bottom_ncdirect
