#!/bin/sh

################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

  [ -z "$BOOT_ROOT" ] && BOOT_ROOT="/flash"
  [ -z "$SYSTEM_ROOT" ] && SYSTEM_ROOT=""

# mount $BOOT_ROOT r/w if required
  READ_ONLY=$(/bin/busybox grep " $BOOT_ROOT " /proc/mounts | /bin/busybox awk '$4~/(^|,)ro($|,)/')
  [ -n "$READ_ONLY" ] && /bin/busybox mount -o remount,rw $BOOT_ROOT

# update bootloader files
  /bin/busybox cp -p $SYSTEM_ROOT/usr/share/bootloader/LICENCE* $BOOT_ROOT
  /bin/busybox cp -p $SYSTEM_ROOT/usr/share/bootloader/bootcode.bin $BOOT_ROOT
  /bin/busybox cp -p $SYSTEM_ROOT/usr/share/bootloader/fixup.dat $BOOT_ROOT
  /bin/busybox cp -p $SYSTEM_ROOT/usr/share/bootloader/fixup_x.dat $BOOT_ROOT
  /bin/busybox cp -p $SYSTEM_ROOT/usr/share/bootloader/start.elf $BOOT_ROOT
  /bin/busybox cp -p $SYSTEM_ROOT/usr/share/bootloader/start_x.elf $BOOT_ROOT

# cleanup not more needed files
  /bin/busybox rm -rf $BOOT_ROOT/loader.bin

# some config.txt magic
  if [ ! -f $BOOT_ROOT/config.txt ]; then
    /bin/busybox cp -p $SYSTEM_ROOT/usr/share/bootloader/config.txt $BOOT_ROOT
  elif [ -z "$(/bin/busybox grep "^[ ]*gpu_mem.*" $BOOT_ROOT/config.txt)" ]; then
    /bin/busybox mv $BOOT_ROOT/config.txt $BOOT_ROOT/config.txt.bk
    /bin/busybox cat $SYSTEM_ROOT/usr/share/bootloader/config.txt \
                     $BOOT_ROOT/config.txt.bk > $BOOT_ROOT/config.txt
  else
    /bin/busybox sed -e "s,# gpu_mem_256=128,gpu_mem_256=100,g" -i $BOOT_ROOT/config.txt
    /bin/busybox sed -e "s,# gpu_mem_512=128,gpu_mem_512=128,g" -i $BOOT_ROOT/config.txt
  fi

# mount $BOOT_ROOT r/o if previously mounted r/w
  /bin/busybox sync
  [ -n "$READ_ONLY" ] && /bin/busybox mount -o remount,ro $BOOT_ROOT
