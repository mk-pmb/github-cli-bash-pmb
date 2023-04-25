#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function array_shift () {
  local VN__= AR__="$1"; shift
  for VN__ in "$@"; do
    [ -z "${VN__%.}" ] || eval "$VN__"'="${'"$AR__"'[0]}"'
    eval "$AR__"'=( "${'"$AR__"'[@]:1}" )'
  done
}










return 0
