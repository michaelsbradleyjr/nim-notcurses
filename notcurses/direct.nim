{.passL: "-lnotcurses -lnotcurses-core".}

import ./api/direct/impl

export impl except setNcdInit, setNcdCoreInit

setNcdInit()
