#!/usr/bin/env bash

main(){

  __o[verbose]=1

  ((__o[verbose])) && {
    declare -gi _stamp
    _stamp=$(date +%s%N)
    ERM $'\n'"---i3Kornhe start---"
  }

  trap 'cleanup' EXIT

  declare -gA _vars_to_set # "i3var"s to set
  declare -g  _msgstring   # combined i3-msg

  # globals for absolute positioning
  __border_top=25 __border_bot=5
  __border_left=5 __border_right=5

  __mode="${1:0:1}"
  __mode="${__mode,,}"

  declare -A i3list
  _array=$(i3list)
  eval "$_array"

  [[ $__mode = x ]] && exit_mode

  # i3list[AWF] # active window floatin (1|0)
  [[ $__mode =~ ^[1-9]$ ]] && ((i3list[AWF]==1)) \
    && move_absolute

  __speed="${__o[speed]:=10} px"

  __dir=${__lastarg,,}
  __dir=${__dir:0:1}

  if [[ $__mode =~ s|m ]] && ((i3list[AWF]==1)); then
    # new mode, clear old
    _vars_to_set[sizemode]=""
    # i3var set sizemode
    curmo=""
    i3var get sizetits || current_tf
  elif [[ $__mode = m ]] && ((i3list[AWF]!=1)) && ((i3list[WSA]==i3list[WSF])); then 
    # if window is tiled and workspace is i3fyra
    i3fyra -m "$__dir" --array "$_array"
    exit
  else
    curmo="$(i3var get sizemode)"
  fi

  case "$__dir" in

    l  ) 
      __varmode="topleft"
      tilesize="shrink width"
    ;;

    r ) 
      __varmode="bottomright"
      tilesize="grow width"
    ;;

    u    ) 
      __varmode="topright"
      tilesize="grow height" 
    ;;

    d  ) 
      __varmode="bottomleft"
      tilesize="shrink height" 
    ;;

  esac

  if ((i3list[AWF]!=1)); then
    # resize tiled
    messy "resize $tilesize ${__speed}"
    # i3-msg -q "resize $tilesize ${__speed};"
  else

    if [[ $__mode = m ]]; then
      __varmode=move
      __title="MOVE"
    else
      __title="SIZE:${curmo:-$__varmode}"
    fi

    if [[ -z $curmo ]]; then 
      enter_mode
    else
      apply_action "$curmo"
    fi
  fi
}

___source="$(readlink -f "${BASH_SOURCE[0]}")"  #bashbud
___dir="${___source%/*}"                        #bashbud
source "$___dir/init.sh"                        #bashbud
main "$@"                                       #bashbud
