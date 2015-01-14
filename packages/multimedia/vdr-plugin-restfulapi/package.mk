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

PKG_NAME="vdr-plugin-restfulapi"
PKG_VERSION="20150114180413unstable"
PKG_REV="0yavdr0~trusty"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://launchpad.net/~yavdr"
PKG_URL="https://launchpad.net/~yavdr/+archive/ubuntu/unstable-vdr/+files/${PKG_NAME}_${PKG_VERSION}-${PKG_REV}.tar.gz"
PKG_SOURCE_DIR="${PKG_NAME}_${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain vdr cxxtools vdr-wirbelscan"
PKG_PRIORITY="optional"
PKG_SECTION="multimedia"
PKG_SHORTDESC="vdr-plugin-restfulapi: the restful API for the VDR/"
PKG_LONGDESC="vdr-plugin-restfulapi allows to access many internals of the VDR via a restful API"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

pre_configure_target() {
  export CFLAGS="$CFLAGS -fPIC -L$SYSROOT_PREFIX/usr/lib -L$SYSROOT_PREFIX/lib"
  export CXXFLAGS="$CXXFLAGS -fPIC -L$SYSROOT_PREFIX/usr/lib -L$SYSROOT_PREFIX/lib"
  export LDFLAGS="$LDFLAGS -fPIC -L$SYSROOT_PREFIX/usr/lib -L$SYSROOT_PREFIX/lib"
}

pre_make_target() {
  # dont build parallel
  MAKEFLAGS=-j1
}

pre_build_target() {                                                                                                                                                                                               
  WIRBELSCAN_DIR=$(get_build_dir vdr-wirbelscan)
  ln -sf $WIRBELSCAN_DIR/wirbelscan_services.h $PKG_BUILD
}

make_target() {
  VDR_DIR=$(get_build_dir vdr)
  make VDRDIR=$VDR_DIR \
    LIBDIR="." \
    LOCALEDIR="./locale"
}

makeinstall_target() {
  : # installation not needed, done by create-addon script
}
