#!/usr/bin/env bash

apply_action(){

  local curmo action floatsize

  ((__o[verbose])) && ERM "f ${FUNCNAME[0]}($*)"

  curmo="$1"
  action=resize

  case "$curmo" in
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

    move )

      case "$_direction" in
        u ) floatsize="up"       ;;
        d ) floatsize="down"     ;;
        l ) floatsize="left"     ;;
        r ) floatsize="right"    ;;
      esac

      action=move
      __title=MOVE
    ;;

  esac

  messy "$action ${floatsize} $_speed"
  set_tf
}
