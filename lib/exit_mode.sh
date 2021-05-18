#!/usr/bin/env bash

exit_mode(){

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}()"

  i3var set i3Kornhe
  messy "mode default"
  messy "[con_id=${last[conid]}] title_format ${last[title]:-%title}"

  exit
}
