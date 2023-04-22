{.passL: "-lnotcurses-core".}

import ./api/impl

export impl except setNcInit, setNcCoreInit

setNcCoreInit()
