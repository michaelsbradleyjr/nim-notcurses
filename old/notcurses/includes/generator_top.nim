# print wrapper to stdout
# static:
#   cDebug()

import std/[sequtils, strutils, uri]

const
  notcursesCommitish {.strdefine.} = "v3.0.9"

  notcursesRepo {.strdefine.} = "https://github.com/dankamongmen/notcurses"

  notcursesRepoUrlEnc = encodeUrl(notcursesRepo)

  notcursesRepoUrlEncShort = notcursesRepoUrlEnc[0..(
    if notcursesRepoUrlEnc.len <= 259: notcursesRepoUrlEnc.len - 1 else: 258)]

  underscores = invalidFilenameChars.mapIt(($it, "_"))

  notcursesRepoUrlEncSafe = notcursesRepoUrlEncShort.multiReplace(underscores)

  notcursesCommitish {.strdefine.} = "v3.0.9"

  notcursesBaseDir {.strdefine.} = getProjectCacheDir(
    "notcurses" / notcursesRepoUrlEncSafe / notcursesCommitish /
    (when isDefined(release): "release" else: "debug"))

  commonCmakeFlags =
    "-DBUILD_EXECUTABLES=off -DUSE_CXX=off -DUSE_DOCTEST=off " &
    "-DUSE_PANDOC=off -DUSE_POC=off"

  notcursesCmakeFlags {.strdefine.} =
    when isDefined(release):
      fmt"-DCMAKE_BUILD_TYPE=Release {commonCmakeFlags}"
    else:
      fmt"-DCMAKE_BUILD_TYPE=Debug {commonCmakeFlags}"

  notcursesOutDir {.strdefine.} = notcursesBaseDir

  notcursesDlUrl {.strdefine.} =
    fmt"{notcursesRepo}/archive/{notcursesCommitish}.tar.gz"

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
