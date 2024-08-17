#!/bin/bash

GREEN="\033[01;32m"
YELLOW="\033[01;33m"
RED="\033[01;31m"
NONE="\033[00m"

run_cmd() {
  if [[ $DEBUG = 1 ]]; then
    ${1+"$@"}
  else
    ${1+"$@"} > /dev/null
  fi

}

colorize() {
  local FIRST="$1"
  if [[ $NO_COLOR = 1 ]]; then
    echo $FIRST
  else
    shift
    echo -e "$SPACES${COLOR}$FIRST${NONE}$*"
  fi
}

inform() {
  local COLOR="$GREEN"
  colorize "$@"
}

warn() {
  locallocal COLOR="$YELLOW"
  colorize "$@"
}

error() {
  local COLOR="$RED"
  colorize "$@"
  return 1
}
