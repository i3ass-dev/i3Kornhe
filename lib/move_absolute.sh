#!/usr/bin/env bash

move_absolute(){

  local dir xpos ypos

  margin_top=${__o[margin-top]:-${__o[margin]:-5}} 
  margin_bottom=${__o[margin-bottom]:-${__o[margin]:-5}}
  margin_left=${__o[margin-left]:-${__o[margin]:-5}} 
  margin_right=${__o[margin-right]:-${__o[margin]:-5}}

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}($*)"
  
  dir=$__lastarg

  ypos=$((
    dir<4 ? i3list[WAY]+margin_top :
    dir<7 ? i3list[WAY]+(i3list[WAH]/2)-(i3list[AWH]/2) 
          : i3list[WAY]+(i3list[WAH]-(i3list[AWH]+margin_bottom))
  ))
  
  xpos=$((
    (dir==1||dir==4||dir==7) ? i3list[WAX]+margin_left :         
    (dir==2||dir==5||dir==8) ? i3list[WAX]+(i3list[WAW]/2-(i3list[AWW]/2))
    : i3list[WAX]+(i3list[WAW]-(i3list[AWW]+margin_right))         
  ))

  messy "[con_id=${i3list[AWC]}] move absolute position $xpos $ypos"
  __title="MOVE"
  set_tf
  exit
}
