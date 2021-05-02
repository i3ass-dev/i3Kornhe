#!/usr/bin/env bash

enter_mode(){ 

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}()"

  i3var set sizemode $__varmode
  i3var get sizetits || current_tf
  i3var set sizecon "${i3list[AWC]}"

  set_tf
  messy mode sizemode

  exit
  # echo "$__varmode"
}
