#!/usr/bin/env bash

main(){

  local next_mode

  # __o[verbose]=1

  ((__o[verbose])) && {
    declare -gi _stamp
    _stamp=$(date +%s%N)
    ERM $'\n'"---i3Kornhe $* start--- "
  }

  trap 'cleanup' EXIT

  declare -g  _msgstring  # combined i3-msg
  declare -g  _array      # output from i3list
  declare -Ag i3list      # i3list array
  declare -Ag last        # array with last i3Kornhe info

  # mode is first arg, size|move|x|0-9 -> s|m|x|0-9
  next_mode="${1:0:1}" ; next_mode="${next_mode,,}"

  # last arg is direction, left|right|up|down -> l|r|u|d
  _direction=${__lastarg:0:1} ; _direction=${_direction,,}

  # remove all none digits from --speed arg
  : "${_speed:=${__o[speed]//[!0-9]}}"
  (( _speed >= 0 )) || _speed=10

  [[ ${_array:=${__o[array]}} ]] || {
    _array=$(i3list ${__o[json]:+--json "${__o[json]}"})
  }

  eval "$_array"

  # we store i3Korhne info a variable like this:
  # MODE:con_id:corner:original_window_title
  re='(s|m):([0-9]+):([^:]+):(.+)'

  [[ $(i3var get i3Kornhe) =~ $re ]] && last=(
    [mode]=${BASH_REMATCH[1]}
    [conid]=${BASH_REMATCH[2]}
    [corner]=${BASH_REMATCH[3]}
    [title]=${BASH_REMATCH[4]}
  )

  if [[ $_direction =~ ^[1-9]$ ]]; then
    next_mode=m
  elif [[ $next_mode = s && ${last[mode]} = s ]]; then
    last[corner]=""
  elif [[ $next_mode != x && $next_mode = $_direction ]]; then
    next_mode=${last[mode]:-x}
  fi

  # reset to default mode if its not the same window
  # having focus as when we initiated i3Korhne.
  [[ $next_mode = x ]] && exit_mode

  # i3list[AWF] # active window floating (1|0)
  if ((i3list[AWF])); then
    modify_floating
  else
    modify_tiled
  fi
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
