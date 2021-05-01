#!/bin/bash

varget() {

  local var re

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}($*)"

  var=$1
  re="\"${var}=([^\"]*)\""

  : "${_mark_json:=$(i3-msg -t get_marks)}"

  [[ $_mark_json =~ $re ]] \
    && echo "${BASH_REMATCH[1]}"

}
