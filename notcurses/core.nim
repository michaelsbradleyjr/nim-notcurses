import # notcurses modules
  ./version

const
  ncAltNames {.strdefine.} = "libnotcurses-core"
  ncHeaderRelPath {.strdefine.} = "include/notcurses/notcurses.h"

include ./includes/imports
include ./includes/defines_notcurses
include ./includes/generator_top
include ./includes/generator_bottom_notcurses
