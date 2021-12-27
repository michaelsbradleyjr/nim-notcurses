# print wrapper to stdout
# static:
#   cDebug()

const
  notcursesBaseDir {.strdefine.} = getProjectCacheDir(
    "notcurses" / (when isDefined(release): "release" else: "debug"))

  notcursesCmakeFlags {.strdefine.} =
    when isDefined(release):
      "-DCMAKE_BUILD_TYPE=Release"
    else:
      "-DCMAKE_BUILD_TYPE=Debug"

  notcursesOutDir {.strdefine.} = notcursesBaseDir

  notcursesRepo {.strdefine.} = "https://github.com/dankamongmen/notcurses"

  notcursesTag {.strdefine.} = "v3.0.2"

  notcursesDlUrl {.strdefine.} =
    fmt"{notcursesRepo}/archive/refs/tags/{notcursesTag}.tar.gz"

getHeader(
  notcursesHeaderRelPath,
  dlUrl = notcursesDlUrl,
  outDir = notcursesOutDir,
  cmakeFlags = notcursesCmakeFlags,
  altNames = notcursesAltNames
)

cPlugin:
  proc onSymbol*(sym: var Symbol) {.exportc, dynlib.} =
    if sym.name == "_Bool": sym.name = "bool"
