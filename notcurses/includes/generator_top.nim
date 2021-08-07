# print wrapper to stdout
# static:
#   cDebug()

const
  sep = when isDefined(windows): "\\" else: "/"

  ncBaseDir {.strdefine.} = getProjectCacheDir(
    "notcurses" & sep & (when isDefined(release): "release" else: "debug"))

  ncCmakeFlags {.strdefine.} =
    when isDefined(release):
      "-DCMAKE_BUILD_TYPE=Release"
    else:
      "-DCMAKE_BUILD_TYPE=Debug"

  ncOutDir {.strdefine.} = ncBaseDir

  ncRepo {.strdefine.} = "https://github.com/dankamongmen/notcurses"

  ncTag {.strdefine.} = versionTag

  ncDlUrl {.strdefine.} = fmt"{ncRepo}/archive/refs/tags/{ncTag}.tar.gz"

getHeader(
  ncHeaderRelPath,
  dlUrl = ncDlUrl,
  outDir = ncOutDir,
  cmakeFlags = ncCmakeFlags,
  altNames = ncAltNames
)

cPlugin:
  proc onSymbol*(sym: var Symbol) {.exportc, dynlib.} =
    if sym.name == "_Bool": sym.name = "bool"
