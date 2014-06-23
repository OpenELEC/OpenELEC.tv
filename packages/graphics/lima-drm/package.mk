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

PKG_NAME="lima-drm"
PKG_VERSION="bd15856"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/tobiasjakobi/lima-drm"
PKG_URL="$LAKKA_MIRROR/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS_TARGET="libdrm toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="graphics"
PKG_SHORTDESC="lima driver with some changes to support output via DRM"
PKG_LONGDESC="lima driver with some changes to support output via DRM"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

export CFLAGS="$CFLAGS -I$SYSROOT_PREFIX/usr/include/libdrm"

make_target() {
  sed -i 's:DIRS = limare tools wrap:DIRS = limare:g' Makefile
  sed -i 's:DIRS = lib tests:DIRS = lib:g' limare/Makefile
  make
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/lib
  cp limare/lib/liblimare.so $INSTALL/usr/lib/
}
