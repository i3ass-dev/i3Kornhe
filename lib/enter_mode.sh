#!/usr/bin/env bash

enter_mode(){ 

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}($*)"

  _vars_to_set[sizemode]=$__varmode
  # i3var set sizemode $__varmode
  varget sizetits || current_tf
  # i3var get sizetits || current_tf

  _vars_to_set[sizecon]=${i3list[AWC]}
  # i3var set sizecon "${i3list[AWC]}"

  set_tf
  messy mode sizemode
  # i3-msg -q mode sizemode

  exit
}
