#!/bin/bash

varset() {

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}(${_v[*]})"

  local key val json re mark current_value

  json=$(i3-msg -t get_marks)

  for key in "${!_vars_to_set[@]}"; do
    val=${_vars_to_set[$key]}

    re="\"${key}=([^\"]*)\""

    [[ $json =~ $re ]] && current_value=${BASH_REMATCH[1]}

    new_mark="${key}=$val"
    old_mark="${key}=$current_value"

    # this will remove the old mark
    [[ $current_value ]] \
      && messy "[con_id=${i3list[RID]}] mark --toggle --add $old_mark"

    [[ $val ]] \
      && messy "[con_id=${i3list[RID]}] mark --add $new_mark"

  done
}
