#!/usr/bin/env bash

exit_mode(){
  local tits

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}($*)"

  _vars_to_set[sizemode]=
  # i3var set sizemode
  messy "mode default"
  # i3-msg -q mode "default"
  tits="$(varget sizetits)"
  # tits="$(i3var get sizetits)"

  [[ -n ${tits:-} ]] \
    && tits="${tits//\\}" \
    || tits='%title'

  sizecon="$(varget sizecon)"
  # sizecon="$(i3var get sizecon)"

  _vars_to_set[sizetits]=
  # i3var set sizetits
  _vars_to_set[sizecon]=
  # i3var set sizecon

  messy "[con_id=$sizecon] title_format ${tits}"
  # i3-msg -q "[con_id=$sizecon]" title_format "${tits}"
  exit
}
