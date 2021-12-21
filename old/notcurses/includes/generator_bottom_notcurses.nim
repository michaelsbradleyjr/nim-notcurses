cOverride:
  type
    ncmenu = object
    nctree = object
    timespec = object
    uintmax_t = BiggestUInt

cIncludeDir(notcursesPath.parentDir.parentDir)

when not isDefined(notcursesStatic):
  cImport(notcursesPath, recurse = true, dynlib = "notcursesLPath")
else:
  cImport(notcursesPath, recurse = true)
