#!/usr/bin/env bash

declare -a modules=(
  cjkscroll
  cli1
  cli2
  direct1
  direct_sgr
  gradients
  multiselect
  tui1
  zalgo
)

for module in ${modules[@]}; do
  echo nim c "$@" examples/${module}.nim
  nim c "$@" examples/${module}.nim
  echo
done
