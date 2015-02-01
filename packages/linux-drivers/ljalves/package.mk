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

PKG_NAME="ljalves"
PKG_VERSION="2015-01-30"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/ljalves/linux_media"
PKG_URL="http://mycvh.de/openelec/ljalves-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET=""
PKG_BUILD_DEPENDS_TARGET="toolchain linux"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="Open Source TBS drivers from Luis Alves"
PKG_LONGDESC="Open Source TBS drivers from Luis Alves"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_make_target() {
  export KERNEL_VER=$(get_module_dir)
  # dont use our LDFLAGS, use the KERNEL LDFLAGS
  export LDFLAGS=""
}

make_target() {
  cd media_build
  make dir DIR=../media
  make VER=$KERNEL_VER SRCDIR=$(kernel_path) distclean
  make VER=$KERNEL_VER SRCDIR=$(kernel_path)
}

makeinstall_target() {
  mkdir -p $INSTALL/lib/modules/$KERNEL_VER/updates/media_build
  find $ROOT/$PKG_BUILD/media_build/v4l/ -name \*.ko -exec strip --strip-debug {} \;
  find $ROOT/$PKG_BUILD/media_build/v4l/ -name \*.ko -exec cp {} $INSTALL/lib/modules/$KERNEL_VER/updates/media_build \;
}