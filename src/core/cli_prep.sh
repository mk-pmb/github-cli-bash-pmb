#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function cli_prep_parse_early_options () {
  local KEY= VAL=
  while true; do
    VAL="${CLI_ARGS[0]}"
    [ "${VAL:0:2}" == -- ] || break
    VAL="${VAL#--}"
    array_shift CLI_ARGS .
    [ -n "$VAL" ] || break
    case "$VAL" in
      *=* ) KEY="${VAL%%=*}"; VAL="${VAL#*=}";;
      * ) KEY="$VAL"; array_shift CLI_ARGS VAL;;
    esac
    CFG["$KEY"]="$VAL"
  done

  cli_prep_check_token || return $?
}


function cli_prep_check_token () {
  local T="${CFG[token]}"
  [ -n "$T" ] || return 4$(echo 'E: No GitHub token given!' \
    'You may want to use --token as the first argument,' \
    'ideally followed by a file path that contains a slash (/).' >&2)

  if [[ "$T" == */* ]]; then
    T="${T/#'~/'/"$HOME/"}"
    CFG[token]="$(grep -xPe '[\w\.\-]+' -m 1 -- "$T")"
    [ -n "${CFG[token]}" ] && return 0
    echo "E: Failed to read GitHub token from file '$T'" >&2
    return 4
  fi
}










return 0
