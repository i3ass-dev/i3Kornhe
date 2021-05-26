#!/bin/sh

modify_floating() {

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}()"

  local title_format corner mark last_title

  declare -i trgx trgy trgw trgh conid
  declare -i margin_t margin_b margin_l margin_r

  trgx=${i3list[AWX]} trgy=${i3list[AWY]}
  trgw=${i3list[AWW]} trgh=${i3list[AWH]}

  conid=${last[conid]:-${i3list[AWC]}}

  # m - move
  if [[ $next_mode = m ]]; then

    title_format="MOVE "

    margin_t=${__o[margin-top]:-${__o[margin]:-5}} 
    margin_b=${__o[margin-bottom]:-${__o[margin]:-5}}
    margin_l=${__o[margin-left]:-${__o[margin]:-5}} 
    margin_r=${__o[margin-right]:-${__o[margin]:-5}}

    # else just move the container
    case "$_direction" in
      l ) ((trgx-=_speed)) ;;
      r ) ((trgx+=_speed)) ;;
      u ) ((trgy-=_speed)) ;;
      d ) ((trgy+=_speed)) ;;
      1 )
        trgx=$(( i3list[WAX]+margin_l ))
        trgy=$(( i3list[WAY]+margin_t ))
      ;;

      2 )
        trgx=$(( i3list[WAX]+(i3list[WAW]/2)-(i3list[AWW]/2) ))
        trgy=$(( i3list[WAY]+margin_t ))
      ;;

      3 )
        trgx=$(( i3list[WAX]+( i3list[WAW]-(i3list[AWW]+margin_r) ) ))
        trgy=$(( i3list[WAY]+margin_t ))
      ;;

      4 )
        trgx=$(( i3list[WAX]+margin_l ))
        trgy=$(( i3list[WAY]+(i3list[WAH]/2)-(i3list[AWH]/2) ))
      ;;

      5 )
        trgx=$(( i3list[WAX]+(i3list[WAW]/2)-(i3list[AWW]/2) ))
        trgy=$(( i3list[WAY]+(i3list[WAH]/2)-(i3list[AWH]/2) ))
      ;;

      6 )
        trgx=$(( i3list[WAX]+( i3list[WAW]-(i3list[AWW]+margin_r) ) ))
        trgy=$(( i3list[WAY]+(i3list[WAH]/2)-(i3list[AWH]/2) ))
      ;;

      7 )
        trgx=$(( i3list[WAX]+margin_l ))
        trgy=$(( i3list[WAY]+( i3list[WAH]-(i3list[AWH]+margin_b) ) ))
      ;;

      8 )
        trgx=$(( i3list[WAX]+(i3list[WAW]/2)-(i3list[AWW]/2) ))
        trgy=$(( i3list[WAY]+( i3list[WAH]-(i3list[AWH]+margin_b) ) ))
      ;;

      9 )
        trgx=$(( i3list[WAX]+( i3list[WAW]-(i3list[AWW]+margin_r) ) ))
        trgy=$(( i3list[WAY]+( i3list[WAH]-(i3list[AWH]+margin_b) ) ))
      ;;

    esac

    messy "[con_id=$conid] move position $trgx $trgy"
    corner=move

  # s - resize
  elif [[ $next_mode = s ]]; then

    [[ ${last[corner]} = move ]] && last[corner]=""
    
    [[ ${corner:=${last[corner]}} ]] || {
      case "$_direction" in
        l ) corner="topleft"     ;;
        r ) corner="bottomright" ;;
        u ) corner="topright"    ;;
        d ) corner="bottomleft"  ;;
      esac
    }

    title_format="RESIZE $corner "

    case "$corner" in
      topleft )
        case "$_direction" in
          u ) floatsize="grow up"      ;;
          d ) floatsize="shrink up"    ;;
          l ) floatsize="grow left"    ;;
          r ) floatsize="shrink left"  ;;
        esac
      ;;

      topright )
        case "$_direction" in
          u ) floatsize="grow up"      ;;
          d ) floatsize="shrink up"    ;;
          l ) floatsize="shrink right" ;;
          r ) floatsize="grow right"   ;;
        esac
      ;;

      bottomleft )
        case "$_direction" in
          u ) floatsize="shrink down"   ;;
          d ) floatsize="grow down"     ;;
          l ) floatsize="grow left"     ;;
          r ) floatsize="shrink left"   ;;
        esac
      ;;

      bottomright )
        case "$_direction" in
          u ) floatsize="shrink down"   ;;
          d ) floatsize="grow down"     ;;
          l ) floatsize="shrink right"  ;;
          r ) floatsize="grow right"    ;;
        esac
      ;;


    esac
    
    i3-msg -q "resize $floatsize $_speed"
    eval "$(i3list)"
    trgx=${i3list[AWX]} trgy=${i3list[AWY]}
    trgh=${i3list[AWH]} trgw=${i3list[AWW]}

  fi

  title_format+="x:$trgx y:$trgy w:$trgw h:$trgh"

  messy "[con_id=$conid] title_format $title_format"

  # MODE:con_id:corner:original_window_title
  last_title=${last[title]:-$(i3get -n "${i3list[AWC]}" -r o)}
  mark="$next_mode:$conid:$corner:${last_title:-%title}"
  i3var set i3Kornhe "$mark"
  messy mode sizemode

}
