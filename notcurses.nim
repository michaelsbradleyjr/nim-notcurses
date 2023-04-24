{.passL: "-lnotcurses -lnotcurses-core".}

import ./notcurses/api/impl

export impl except setNcInit, setNcCoreInit

setNcInit()
