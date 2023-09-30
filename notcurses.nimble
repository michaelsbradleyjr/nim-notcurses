packageName  = "notcurses"
version      = "3.0.9"
author       = "Michael Bradley, Jr."
description  = "A wrapper for Notcurses"
license      = "Apache-2.0 or MIT"
installDirs  = @["notcurses"]
installFiles = @["LICENSE", "LICENSE-APACHEv2", "LICENSE-MIT", "LICENSE-NOTCURSES", "notcurses.nim"]

requires "nim >= 1.6.0",
         "results",
         "stew",
         "unittest2"
