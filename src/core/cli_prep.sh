#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function cli_prep_parse_early_options () {
  local KEY= VAL=
  while [ "${#CLI_ARGS[@]}" -ge 1 ]; do
    VAL="${CLI_ARGS[0]}"
    case "$VAL" in
      -H | --header | -X | --request )
        echo E: "The $VAL option you provided looks like you may have meant:" \
          "ghapi curl /some/api/endpoint $VAL '${CLI_ARGS[1]}'" >&2
        return 3;;
      -- ) break;;
      --* ) VAL="${VAL#--}"; array_shift CLI_ARGS . ;;
      * ) break;;
    esac
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
