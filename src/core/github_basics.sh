#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ghapi_cli_curl () {
  local URL="$1"; shift
  [ "${URL:0:1}" == / ] && URL="https://api.github.com$URL"
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
