packageName   = "notcurses"
version       = "3.0.1"
author        = "Michael Bradley, Jr."
description   = "A wrapper for Notcurses"
license       = "Apache License 2.0 or MIT"
installDirs = @["notcurses"]
installFiles  = @["notcurses.nim"]

# prefer #head of nimterop until this commit is included in a tagged version:
# 4be3518141a365ce2f2ad90925defefa9c738554
requires "nimterop#head"
