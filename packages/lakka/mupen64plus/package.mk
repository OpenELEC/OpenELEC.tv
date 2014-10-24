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

PKG_NAME="mupen64plus"
PKG_VERSION="2251b3a"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv3"
PKG_SITE="https://github.com/libretro/mupen64plus-libretro"
PKG_URL="$LAKKA_MIRROR/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS=""
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="RetroArch"
PKG_SHORTDESC="Libretro GL only. Libretro port of Mupen64 Plus."
PKG_LONGDESC="Libretro GL only. Libretro port of Mupen64 Plus."

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
  DYNAREC=$ARCH

  if [ "$ARCH" == "i386" ]; then
    DYNAREC=x86
  fi

  if [ "$PROJECT" == "RPi" ]; then
    make platform=rpi
  elif [ "$PROJECT" == "WandBoard" ] || [ "$PROJECT" == "Cuboxi" ]; then
    make platform=imx6
  else
    make WITH_DYNAREC=$DYNAREC
  fi
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp mupen64plus_libretro.so $INSTALL/usr/lib/libretro/mupen64plus_libretro.so
}
