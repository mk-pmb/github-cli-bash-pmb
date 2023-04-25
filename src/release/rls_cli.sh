#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ghapi_cli_release () {
  local -A RLS=()
  array_shift CLI_ARGS RLS[url]
  local BUF=
  ghapi_parse_repo_suburl "${RLS[url]}" RLS BUF || BUF=

  case "$BUF" in
    releases ) ;;
    releases/tag/* )
      BUF="${BUF#releases/}"
      RLS[id]="$BUF"
      ;;
    * )
      echo "E: release (draft) URL should match pattern" \
        'https://github.com/*/*/releases/tag/*' >&2
      return 3;;
  esac

  ghapi_release_detect_rls_id || return $?

  local RLS_TASK=
  array_shift CLI_ARGS RLS_TASK
  [ -n "$RLS_TASK" ] || RLS_TASK='get'
  "ghapi_release_$RLS_TASK" "$@"; return $?
}


function ghapi_release_get () {
  local URL="/repos/${RLS[owner]}/${RLS[repo]}/releases"
  [ -n "${RLS[id]}" ] && URL+="/${RLS[id]}"
  ghapi_cli_curl "$URL"
}











return 0
