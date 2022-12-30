import std/os

--path:".."

const
  configPath = currentSourcePath.parentDir.parentDir
  cacheSubdirHead = joinPath(configPath, "nimcache")
  cacheSubdirTail = joinPath(relativePath(projectDir(), configPath), projectName())
  cacheSubdir = joinPath(cacheSubdirHead, (if defined(release): "release" else: "debug"), cacheSubdirTail)

switch("nimcache", cacheSubdir)

--tlsEmulation:off
when (NimMajor, NimMinor) < (2, 0):
  --threads:on

when (NimMajor, NimMinor) <= (1, 2):
  switch("hint", "Processing:off")
  switch("hint", "XDeclaredButNotUsed:off")
  switch("warning", "ObservableStores:off")
else:
  --hint:"XCannotRaiseY:off"

when (NimMajor, NimMinor, NimPatch) < (1, 6, 2):
  --gc:refc
elif (NimMajor, NimMinor) < (2, 0):
  --mm:refc

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
