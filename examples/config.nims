import std/os

--path:".."

const
  cfgPath = currentSourcePath.parentDir
  topPath = cfgPath.parentDir
  cacheSubdirHead = joinPath(topPath, "nimcache")
  cacheSubdirTail = joinPath(relativePath(projectDir(), topPath), projectName())
  cacheSubdir = joinPath(cacheSubdirHead, (if defined(release): "release" else: "debug"), cacheSubdirTail)

switch("nimcache", cacheSubdir)

--tlsEmulation:off
when (NimMajor, NimMinor) < (2, 0):
  # starting with Nim 2.0 --threads:on is the default
  --threads:on

when (NimMajor, NimMinor) <= (1, 2):
  switch("hint", "Processing:off")
  switch("hint", "XDeclaredButNotUsed:off")
  switch("warning", "ObservableStores:off")
else:
  --hint:"XCannotRaiseY:off"

# same as defaults for these versions, but convenient for experimentation
when (NimMajor, NimMinor, NimPatch) < (1, 6, 2):
  --gc:refc
elif (NimMajor, NimMinor) < (2, 0):
  --mm:refc
else:
  --mm:orc

when defined(release):
  --define:strip
  --hints:off
  --opt:speed
  --passC:"-flto"
  --passL:"-flto"
else:
  --debugger:native
  --define:debug
  --linetrace:on
  --stacktrace:on
