#!/usr/bin/env bash

set -eo pipefail

declare -a modules=(
  abi/cjkscroll
  abi/cli1
  abi/cli2
  abi/direct1
  abi/direct_sgr
  abi/gradients
  abi/multiselect
  abi/tui1
  abi/zalgo
  cjkscroll
  cli1
  cli2
  direct1
  direct_sgr
  gradients
  tui1
  zalgo
)

for module in ${modules[@]}; do
  echo nim c "$@" examples/${module}.nim
  nim c "$@" examples/${module}.nim
  echo
done

if [[ -v MSYSTEM ]]; then
  ls -ladh examples/abi/*.exe examples/*.exe
else
  find examples -maxdepth 2 -type f | grep -v '\..*$' | xargs ls -ladh
fi
