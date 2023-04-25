#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ghapi_release_detect_rls_id () {
  local ORIG="${RLS[id]}"
  [ -n "${ORIG//[0-9]/}" ] || return 0
  echo "D: Found non-digits in release ID => trying to look it up."
  RLS[id]=
  local LIST_JSON="$DEBUG_STUB_RELEASES_LIST_JSON"
  case "$LIST_JSON" in
    /* | ./* | ../* | *.json ) LIST_JSON="$(cat -- "$LIST_JSON")";;
    '' ) LIST_JSON="$(ghapi_release_get)";;
  esac

  local SED_GRAB='
    s~^    "url": "https://api\.github\.com/repos(/[A-Za-z0-9_.-]+|$\
      ){2}/releases/([0-9]+)",?$~< id: \2 >~p
    s~^    "html_url": "https://github\.com(/[A-Za-z0-9_.-]+|$\
      ){2}/releases/([^"]+)",?$~< hu: \2 >~p
    s~^  \},?$~~p
    '
  local SED_MERGE='
    : read_more
    /\n$/!{N;b read_more}
    s~\n~~g
    s~^(< hu: \S+ >)(< id: \S+ >)$~\2\1~
    s~^< id: (\S+) >< hu: (\S+) >$~< \2 >\1~p
    '
  local FOUND="$( <<<"$LIST_JSON" sed -nrf <(echo "$SED_GRAB"
    ) | sed -nrf <(echo "$SED_MERGE") )"
  [ -n "$FOUND" ] || return 8$(echo 'E: Found no release IDs at all!' >&2)
  FOUND="$(<<<"$FOUND" grep -Fe "< $ORIG >")"
  FOUND="${FOUND##*>}"
  [ -n "$FOUND" ] || return 8$(
    echo "E: Found no release ID for HTML URL '$ORIG'!" >&2)
  RLS[id]="$FOUND"
}











return 0
