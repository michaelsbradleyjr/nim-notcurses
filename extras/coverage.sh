#!/usr/bin/env bash

set -eo pipefail

source extras/examples.sh

maintainer=michaelsbradleyjr
project=notcurses
repo=nim-notcurses

bred='\033[1;31m'
byel='\033[1;33m'
none='\033[0m'

if [[ "$@" = *"-d:release"* || "$@" = *"--define:release"* ]]; then
  kind=release
else
  kind=debug
fi

press_any () {
  echo -e "\n${byel}Press any key to continue${none}"
  read -n 1 -s -r
}

for module in ${modules[@]}; do
  echo
  echo nim c -d:coverage "$@" examples/${module}.nim
  if [[ ! ("$@" = *"-d:release"* || "$@" = *"--define:release"*) ]]; then
    echo
  fi
  nim c -d:coverage "$@" examples/${module}.nim
done

echo
if [[ -v MSYSTEM ]]; then
  ls -ladh examples/*.exe
else
  find examples -maxdepth 1 -type f | grep -v '\..*$' | xargs ls -ladh
fi

for module in ${modules[@]}; do
  if [[ ! -v GITHUB_ACTIONS ]]; then
    press_any
    clear && reset
  else
    echo
  fi
  mkdir -p coverage/examples/${module}
  if [[ -v MSYSTEM ]]; then
    echo examples/${module}.exe
    echo
    examples/${module}.exe
  else
    echo examples/${module}
    echo
    examples/${module}
  fi
  if [[ ! -v GITHUB_ACTIONS ]]; then
    press_any
    clear && reset
  else
    echo
  fi
  (find nimcache/${kind}/examples/${module} | grep 'choosenim\|nimble' \
   | xargs rm) 2>/dev/null || true
  lcov --capture \
       --directory nimcache/${kind}/examples/${module} \
       --ignore-errors gcov,gcov \
       >> coverage/examples/${module}/coverage.info
  echo
  lcov --add-tracefile \
       coverage/examples/${module}/coverage.info \
       >> coverage/coverage.info
done

if [[ ! -v GITHUB_ACTIONS ]]; then
  press_any
  clear && reset
else
  echo
fi
mkdir -p coverage/tests/test_all
echo nimble --verbose test -d:coverage "$@"
echo
nimble --verbose test -d:coverage "$@"
if [[ ! -v GITHUB_ACTIONS ]]; then
  press_any
  clear && reset
else
  echo
fi
(find nimcache/${kind}/examples/${module} | grep 'choosenim\|nimble' \
 | xargs rm) 2>/dev/null || true
lcov --capture \
     --directory nimcache/${kind}/tests/test_all \
     --ignore-errors gcov,gcov \
     >> coverage/tests/test_all/coverage.info
echo
lcov --add-tracefile \
     coverage/tests/test_all/coverage.info \
     >> coverage/coverage.info

if [[ ! -v GITHUB_ACTIONS ]]; then
  press_any
  clear && reset
else
  echo
fi
echo Extracting tracefiles.
if [[ -v MSYSTEM ]]; then
  lcov --extract coverage/coverage.info \
       --ignore-errors unused \
       "$(cygpath -w "${PWD}"/${project}.nim)" \
       "$(cygpath -w "${PWD}"/${project}/)"\*.nim \
       >> coverage/extracted.info
else
  lcov --extract coverage/coverage.info \
       --ignore-errors unused \
       "${PWD}"/${project}.nim \
       "${PWD}"/${project}/\*.nim \
       >> coverage/extracted.info
fi
echo
echo Processing extracted tracefiles.
if [[ "$(lcov --version)" = *"version 1"* ]]; then
  genhtml coverage/extracted.info \
          --legend \
          --output-directory coverage/report \
          --title ${repo}
else
  genhtml coverage/extracted.info \
          --ignore-errors unmapped,unmapped \
          --legend \
          --output-directory coverage/report \
          --title ${repo}
fi

if [[ ! -z "${CODECOV_TOKEN}" ]]; then
  if [[ ! -v GITHUB_ACTIONS ]]; then
    press_any
    clear && reset
  else
    echo
  fi
  echo Uploading coverage report.
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
  if [[ -v MSYSTEM ]]; then
    coverage/codecov \
      --branch "$(git rev-parse --abbrev-ref HEAD)" \
      --file coverage\\extracted.info \
      --rootDir "$(cygpath -w "${PWD}")" \
      --sha "$(git rev-parse $(git rev-parse --abbrev-ref HEAD))"
  else
    coverage/codecov \
      --branch "$(git rev-parse --abbrev-ref HEAD)" \
      --file coverage/extracted.info \
      --sha "$(git rev-parse $(git rev-parse --abbrev-ref HEAD))"
  fi
  [[ -v GITHUB_ACTIONS ]] \
    || (((open https://codecov.io/gh/${maintainer}/${repo}) 2>/dev/null \
    && echo -e "\nopen https://codecov.io/gh/${maintainer}/${repo}") \
    || true)
fi

[[ -v GITHUB_ACTIONS ]] \
  || (((open coverage/report/index.html) 2>/dev/null \
  && echo -e "\nopen coverage/report/index.html") \
  || true)
