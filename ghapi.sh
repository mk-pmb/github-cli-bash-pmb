#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ghapi_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  # cd -- "$SELFPATH" || return $?

  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  local SELFPATH="$(readlink -m -- "$BASH_SOURCE"/..)"
  source_these_libs '
    core/*
    ' || return $?

  local -A CFG=(
    [token]="$GITHUB_TOKEN"
    )
  local CLI_ARGS=( "$@" )
  cli_prep_parse_early_options || return $?

  array_shift CLI_ARGS TASK
  [ -n "$TASK" ] || return 3$(echo "E: No task name given." >&2)
  source_these_libs "$TASK/?" || return $?
  ghapi_cli_"$TASK" "$@" || return $?$(echo "E: Task $TASK failed, rv=$?" >&2)
}


function source_these_libs () {
  local LIBS=()
  local LIB=
  for LIB in $*; do
    if [[ "$LIB" == *'/?' ]]; then
      LIB="${LIB%'?'}"
      [ -d "$SELFPATH"/src/"$LIB" ] || continue
      LIB+='*'
    fi
    eval 'LIBS+=( "$SELFPATH"/src/'"$LIB"'.sh )'
  done
  for LIB in "${LIBS[@]}"; do
    source -- "$LIB" --lib || return $?$(echo "E: failed to source $LIB" >&2)
  done
}










ghapi_cli_init "$@"; exit $?
