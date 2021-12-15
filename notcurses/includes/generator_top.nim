# print wrapper to stdout
# static:
#   cDebug()

import std/[sequtils, strutils, uri]

const
  notcursesRepo {.strdefine.} = "https://github.com/dankamongmen/notcurses"

  notcursesRepoUrlEnc = encodeUrl(notcursesRepo)

  notcursesRepoUrlEncShort = notcursesRepoUrlEnc[0..(
    if notcursesRepoUrlEnc.len <= 259: notcursesRepoUrlEnc.len - 1 else: 258)]

  underscores = invalidFilenameChars.mapIt(($it, "_"))

  notcursesRepoUrlEncSafe = notcursesRepoUrlEncShort.multiReplace(underscores)

  notcursesTag {.strdefine.} = "v3.0.1"

  notcursesBaseDir {.strdefine.} = getProjectCacheDir(
    "notcurses" / notcursesRepoUrlEncSafe / notcursesTag /
    (when isDefined(release): "release" else: "debug"))

  notcursesCmakeFlags {.strdefine.} =
    when isDefined(release):
      "-DCMAKE_BUILD_TYPE=Release -DUSE_CXX=off -DUSE_DOCTEST=off " &
      "-DUSE_PANDOC=off -DUSE_POC=off"
    else:
      "-DCMAKE_BUILD_TYPE=Debug -DUSE_CXX=off -DUSE_DOCTEST=off " &
      "-DUSE_PANDOC=off -DUSE_POC=off"

  notcursesOutDir {.strdefine.} = notcursesBaseDir

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
