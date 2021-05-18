#!/bin/sh

modify_tiled() {

  local tilesize

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}()"

  # m - move
  if [[ $next_mode = m ]]; then

    # if window is tiled and active workspace is i3fyra
    (( i3list[AWF]!=1 && i3list[WSA]==i3list[WSF])) \
      && exec i3fyra --move "$_direction" --array "$_array"

    # else just move the container
    case "$_direction" in
      l ) _direction=left  ;;
      r ) _direction=right ;;
      u ) _direction=up    ;;
      d ) _direction=down  ;;
    esac

    messy "move $_direction"

  # s - resize
  elif [[ $next_mode = s ]]; then

    case "$_direction" in
      l ) tilesize="shrink width"  ;;
      r ) tilesize="grow width"    ;;
      u ) tilesize="grow height"   ;;
      d ) tilesize="shrink height" ;;
    esac

    messy "resize $tilesize $_speed px"
  fi

}
