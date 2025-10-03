#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ghapi_cli_curl () {
  local URL="$1"; shift
  case "$URL" in
    /* ) URL="${CFG[api_host]}$URL";;
    "${CFG[api_host]}"/* ) ;;
    * )
      echo E: 'Expected arg 1 (URL) to start with /' \
        "or '${CFG[api_host]}' but got: '$URL'" >&2
      return 4;;
  esac
  local CURL_ARGS=(
    --location
    --show-error
    --no-progress-meter
    --verbose
    --header 'Accept: application/vnd.github+json'
    --header 'Authorization: Bearer '"${CFG[token]}"
    --header 'X-GitHub-Api-Version: 2022-11-28'
    )
  curl "${CURL_ARGS[@]}" "$@" "$URL"; return $?
}


function ghapi_parse_repo_suburl () {
  # args: URL, dict name, remainder dest
  [ "$3" == BUF ] || local BUF=
  [[ "$1" == https://github.com/*/*/* ]] || return 3$(
    echo "E: URL doesn't look like it's inside a GitHub repo: '$1'" >&2)
  BUF="${1#https://github.com/}"
  eval "$2"'[owner]="${BUF%%/*}"'; BUF="${BUF#*/}"
  eval "$2"'[repo]="${BUF%%/*}"'; BUF="${BUF#*/}"
  [ "$3" == BUF ] || eval "$3"'="$BUF"'
}










return 0
