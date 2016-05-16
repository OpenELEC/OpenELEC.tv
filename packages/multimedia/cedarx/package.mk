################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2014 Stephan Raue (stephan@openelec.tv)
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

PKG_NAME="cedarx"
PKG_VERSION="20150512"
PKG_REV="1"
PKG_ARCH="arm"
PKG_LICENSE="nonfree"
PKG_SITE="http://www.allwinnertech.com/"
PKG_URL="http://down.nu/packages/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="CedarX library"
PKG_LONGDESC="CedarX library uses VPU for video decoding"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

make_target() {
 : # nothing to do
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/include/cedarx
    cp -PR include/* $SYSROOT_PREFIX/usr/include/cedarx
    
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp -PR lib/*.so* $SYSROOT_PREFIX/usr/lib

  mkdir -p $INSTALL/usr/lib
    cp -PR lib/*.so* $INSTALL/usr/lib
}

