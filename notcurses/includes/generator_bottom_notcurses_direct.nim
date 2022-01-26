cOverride:
  type
    ncalign_e = object
    ncblitter_e = object
    nccapabilities = object
    ncdirect = object
    ncinput = object
    ncmenu = object
    ncplane = object
    ncscale_e = object
    ncstreamcb = pointer
    nctree = object
    ncvisual = object
    ncvisual_options = object
    timespec = object
    uintmax_t = BiggestUInt

cIncludeDir(directPath.parentDir.parentDir)

cImport(directPath, recurse = true)
