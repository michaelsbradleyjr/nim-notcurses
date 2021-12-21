cOverride:
  type
    ncmenu = object
    nctree = object
    timespec = object
    uintmax_t = BiggestUInt

cIncludeDir(notcursesPath.parentDir.parentDir)

cImport(notcursesPath, recurse = true)
