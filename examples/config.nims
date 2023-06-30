import std/os

--path:".."

const
  cfgPath = currentSourcePath.parentDir
  topPath = cfgPath.parentDir
  cacheSubdirHead = joinPath(topPath, "nimcache")
  cacheSubdirTail = joinPath(relativePath(projectDir(), topPath), projectName())
  cacheSubdir = joinPath(cacheSubdirHead,
    (if defined(release): "release" else: "debug"), cacheSubdirTail)

switch("nimcache", cacheSubdir)

# same as defaults for these versions, but convenient for experimentation
when (NimMajor, NimMinor, NimPatch) < (1, 6, 2):
  --gc:refc
# elif (NimMajor, NimMinor) < (2, 0):
elif (NimMajor, NimMinor, NimPatch) < (1, 9, 1):
  --mm:refc
else:
  --mm:orc

--panics:on
--threads:on
--tlsEmulation:off

--hint:"XCannotRaiseY:off"
when (NimMajor, NimMinor, NimPatch) > (1, 6, 10):
  --warning:"BareExcept:on"

when defined(release):
  --hints:off
  --opt:size
  --passC:"-flto"
  --passL:"-flto"
  --passL:"-s"
else:
  --debugger:native
  --define:debug
  --linetrace:on
  --stacktrace:on
when defined(coverage):
  when defined(release):
    --debugger:native
  --passC:"--coverage"
  --passL:"--coverage"

# with `--passL:"-s"` macOS Xcode's `ld` will report: "ld: warning: option -s
# is obsolete and being ignored"; however, the resulting binary will still be
# about 15K smaller; supplying `--define:strip` or `switch("define", "strip")`
# in config.nims does not produce an equivalent binary, though manually passing
# the same `--define/-d:strip` as an option to `nim c` on the command-line does
# produce an equivalent binary
