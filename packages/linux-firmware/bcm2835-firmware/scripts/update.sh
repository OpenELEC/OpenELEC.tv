#!/bin/sh

################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#
#  OpenELEC is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 2 of the License, or
#  (at your option) any later version.
#
#  OpenELEC is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

UPDATE_FILES="LICENCE* bootcode.bin fixup.dat start.elf *.dtb"
CLEANUP_FILES="FSCK*.REC loader.bin fixup_x.dat start_x.elf"

message() {
  if [ -e /dev/psplash_fifo ] ; then
    usleep 500000
    echo "MSG $1" > /dev/psplash_fifo
  else
    echo "$1"
  fi
}

[ -z "$BOOT_ROOT" ] && BOOT_ROOT="/flash"
[ -z "$SYSTEM_ROOT" ] && SYSTEM_ROOT=""

# mount $BOOT_ROOT r/w
  mount -o remount,rw $BOOT_ROOT

# cleanup overlays and fsck files (if there)
  for i in $CLEANUP_FILES; do
    for j in $(ls $BOOT_ROOT/$i); do
      message "cleanup $j ..."
      rm -rf $j
    done
  done

# update bootloader files
  for i in $UPDATE_FILES; do
    for j in $(ls $SYSTEM_ROOT/usr/share/bootloader/$i); do
      message "updating $(basename $j) ..."
      rm -rf $BOOT_ROOT/$(basename $j)
      cp -p $j $BOOT_ROOT
    done
  done

  rm -rf $BOOT_ROOT/overlays
  cp -pRv $SYSTEM_ROOT/usr/share/bootloader/overlays $BOOT_ROOT

# some config.txt magic
  if [ ! -f $BOOT_ROOT/config.txt ]; then
    cp -p $SYSTEM_ROOT/usr/share/bootloader/config.txt $BOOT_ROOT
  elif [ -z "`grep "^[ ]*gpu_mem.*" $BOOT_ROOT/config.txt`" ]; then
    mv $BOOT_ROOT/config.txt $BOOT_ROOT/config.txt.bk
    cat $SYSTEM_ROOT/usr/share/bootloader/config.txt \
        $BOOT_ROOT/config.txt.bk > $BOOT_ROOT/config.txt
  fi
