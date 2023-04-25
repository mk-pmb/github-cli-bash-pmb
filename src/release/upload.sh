#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ghapi_release_upload () {
  local BASE_URL='https://uploads.github.com/repos/'$(
    )"${RLS[owner]}/${RLS[repo]}/releases/${RLS[id]}/assets?name="

  local ARG=
  array_shift CLI_ARGS ARG
  [ "$ARG" == -- ] || return 3$(
    echo "E: Separator '--' is mandatory in front of the filenames list!" >&2)
  local CNT="${#CLI_ARGS[@]}"
  [ "$CNT" -ge 1 ] || return 3$(echo "E: No filenames given!" >&2)

  local HEADERS=(
    )
  local FILE= NUM=0 URL= REPLY=
  local MID_OPT=(
    --request POST
    --header 'Content-Type: application/octet-stream'
    --data-binary
    )
  for FILE in "${CLI_ARGS[@]}"; do
    (( NUM += 1 ))
    echo -n "File $NUM/$CNT: $FILE … "
    URL="$BASE_URL$(basename -- "$FILE")"
    REPLY="$( ghapi_cli_curl "$URL" "${MID_OPT[@]}" "@$FILE" 2>&1 )"
    echo "<< $REPLY >>"
    echo "<< $REPLY >>" >reply.txt
  done
  echo
}










