#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function ghapi_cli_debug_locals () {
  eval "local ${1//;/; local }"; shift
  "$@"; echo "<< rv=$? >>"
  local -p
}










return 0
