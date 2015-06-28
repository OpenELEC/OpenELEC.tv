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

PKG_NAME="mame"
PKG_VERSION="865ae6a"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="MAME"
PKG_SITE="https://github.com/libretro/mame-libretro.git"
PKG_URL="$LAKKA_MIRROR/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="libretro"
PKG_SHORTDESC="MAME - Multiple Arcade Machine Emulator"
PKG_LONGDESC="MAME - Multiple Arcade Machine Emulator"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {

  #sed -i -e "s/\tCC_AS = gcc/\tCC_AS = \$\(CC\)/" Makefile.libretro
  #sed -i -e "s/\tCC = g++//" Makefile.libretro
  #sed -i -e "s/\tNATIVECC = g++/\tNATIVECC = \$\(CXX\)/" Makefile.libretro
  #sed -i -e "s/\tAR = @ar//" Makefile.libretro
  #sed -i -e "s/\tLD = g++//" Makefile.libretro
  #sed -i -e "s/\tNATIVELD = g++/\tNATIVELD = \$\(CXX\)/" Makefile.libretro
  ##sed -i -e "s/-Wl,--version-script=src\/osd\/retro\/link.T//" Makefile.libretro
  ##sed -i -e "s/-Wl,--no-undefined//" Makefile.libretro
  ##sed -i -e "s/-Wl,--warn-common//" Makefile.libretro
  #sed -i -e "s/CONLYFLAGS = -fpermissive//" Makefile.libretro
  echo $CC
  make -f Makefile.libretro DISTRO="" OVERRIDE_CC="$CC" CROSS_BUILD=""
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib/libretro
  cp 0152/mame_libretro.so $INSTALL/usr/lib/libretro/
}
