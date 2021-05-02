#!/bin/bash

cleanup() {

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}()"

  local qflag

  ((__o[verbose])) || qflag='-q'

  ((${#_vars_to_set[@]})) && varset

  [[ -n $_msgstring ]] && i3-msg "${qflag:-}" "$_msgstring"

  ((__o[verbose])) && {
    local delta=$(( ($(date +%s%N)-_stamp) /1000 ))
    local time=$(((delta / 1000) % 1000))
    ERM  "---i3Kornhe done: ${time}ms---"
  }
}
