packageName   = "notcurses"
version       = "3.0.9"
author        = "Michael Bradley, Jr."
description   = "A wrapper for Notcurses"
license       = "Apache License 2.0 or MIT"
installDirs = @["notcurses"]
installFiles  = @["notcurses.nim"]

### Dependencies
requires "nim >= 1.2.12",
  "nimterop >= 0.6.13"
