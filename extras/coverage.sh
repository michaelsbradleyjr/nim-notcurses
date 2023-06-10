#!/usr/bin/env bash

set -eo pipefail

bred='\033[1;31m'
none='\033[0m'
if [[ "$(lcov --version)" = *"version 1"* ]]; then
  echo -e ${bred}Error${none}: lcov must be version 2 or newer
  lcov --version
  exit 1
fi

source extras/examples.sh

for module in ${modules[@]}; do
  if [[ "${module}" = "abi/"* ]]; then
    continue
  fi
  echo
  echo nim c -d:coverage "$@" examples/${module}.nim
  if [[ ! ("$@" = *"-d:release"* || "$@" = *"--define:release"*) ]]; then
    echo
  fi
  nim c -d:coverage "$@" examples/${module}.nim
done

echo
if [[ -v MSYSTEM ]]; then
  ls -ladh examples/abi/*.exe examples/*.exe
else
  find examples -maxdepth 2 -type f | grep -v '\..*$' | xargs ls -ladh
fi

if [[ "$@" = *"-d:release"* || "$@" = *"--define:release"* ]]; then
  kind=release
else
  kind=debug
fi

for module in ${modules[@]}; do
  if [[ "${module}" = "abi/"* ]]; then
    continue
  fi
  sleep 1
  mkdir -p coverage/examples/${module}
  echo
  clear && reset
  if [[ -v MSYSTEM ]]; then
    echo examples/${module}.exe
    echo
    examples/${module}.exe
  else
    echo examples/${module}
    echo
    examples/${module}
  fi
  find nimcache/${kind}/examples/${module} | grep 'choosenim\|nimble' | xargs rm
  echo
  lcov --capture \
       --directory nimcache/${kind}/examples/${module} \
       --ignore-errors gcov,gcov \
       >> coverage/examples/${module}/coverage.info
  echo
  lcov --add-tracefile \
       coverage/examples/${module}/coverage.info \
       >> coverage/coverage.info
done

sleep 1
mkdir -p coverage/tests/test_all
echo
clear && reset
echo nimble --verbose test -d:coverage "$@"
echo
nimble --verbose test -d:coverage "$@"
find nimcache/${kind}/tests/test_all | grep 'choosenim\|nimble' | xargs rm
echo
lcov --capture \
     --directory nimcache/${kind}/tests/test_all \
     --ignore-errors gcov,gcov \
     >> coverage/tests/test_all/coverage.info
echo
lcov --add-tracefile \
     coverage/tests/test_all/coverage.info \
     >> coverage/coverage.info

echo
lcov --extract coverage/coverage.info \
     --ignore-errors unused \
     "${PWD}"/notcurses.nim \
     "${PWD}"/notcurses/\*.nim \
     >> coverage/extracted.info

echo
genhtml coverage/extracted.info \
        --ignore-errors unmapped,unmapped \
        --legend \
        --output-directory coverage/report \
        --title nim-notcurses

if [[ ! -z "${CODECOV_TOKEN}" ]]; then
  cd coverage
  if [[ $(uname) = "Linux" ]]; then
    curl -Os https://uploader.codecov.io/latest/linux/codecov
  elif [[ $(uname) = "Darwin" ]]; then
    curl -Os https://uploader.codecov.io/latest/macos/codecov
  elif [[ -v MSYSTEM ]]; then
    curl -Os https://uploader.codecov.io/latest/windows/codecov.exe
  else
    echo -e ${bred}Error${none}: codecov uploader binary is only available for \
            Linux, macOS, and Windows
    exit 1
  fi
  chmod +x codecov
  cd - 1>/dev/null
  echo
  coverage/codecov \
    --file coverage/extracted.info \
    --branch "$(git rev-parse --abbrev-ref HEAD)" \
    --sha "$(git rev-parse $(git rev-parse --abbrev-ref HEAD))"
  if which open >/dev/null; then
    (open https://codecov.io/gh/michaelsbradleyjr/nim-notcurses) || true
  fi
fi

if which open >/dev/null; then
  (open coverage/report/index.html) || true
fi
