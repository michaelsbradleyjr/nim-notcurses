import # notcurses modules
  notcurses/version

const
  ncAltNames {.strdefine.} = "libnotcurses"
  ncHeaderRelPath {.strdefine.} = "include/notcurses/notcurses.h"

include notcurses/includes/imports
include notcurses/includes/defines_notcurses
include notcurses/includes/generator_top
include notcurses/includes/generator_bottom_notcurses
