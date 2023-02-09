packageName  = "notcurses"
version      = "3.0.9"
author       = "Michael Bradley, Jr."
description  = "A wrapper for Notcurses"
license      = "Apache License 2.0 or MIT"
installDirs  = @["notcurses"]
installFiles = @["LICENSE-APACHEv2", "LICENSE-MIT", "LICENSE-NOTCURSES", "notcurses.nim"]

requires "nim >= 1.2.0",
         "stew#head"
