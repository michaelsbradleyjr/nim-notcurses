packageName   = "notcurses"
version       = "3.0.1"
author        = "Michael Bradley, Jr."
description   = "A wrapper for Notcurses"
license       = "Apache License 2.0 or MIT"
installDirs = @["notcurses"]
installFiles  = @["notcurses.nim"]

# prefer #head of nimterop until the following commit is in a tagged version:
# https://github.com/nimterop/nimterop/commit/4be3518
requires "nimterop#head"
