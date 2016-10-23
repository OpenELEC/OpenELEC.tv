################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
#      Copyright (C) 2013 Dag Wieers (dag@wieers.com)
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

PKG_NAME="newt"
PKG_VERSION="0.52.19"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="https://fedorahosted.org/newt/"
PKG_URL="https://fedorahosted.org/releases/n/e/newt/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain popt slang"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="newt: library for color text mode, widget based user interfaces"
PKG_LONGDESC="Newt is a programming library for color text mode, widget based user interfaces. Newt can be used to add stacked windows, entry widgets, checkboxes, radio buttons, labels, plain text fields, scrollbars, etc., to text mode user interfaces. Newt is based on the S-Lang library."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--without-python --without-tcl"

pre_configure_target() {
 # newt fails to build in subdirs
 cd $ROOT/$PKG_BUILD
   rm -rf .$TARGET_NAME
}

make_target() {
  make libnewt.a
  make whiptail
}

makeinstall_target() {
  mkdir -p $SYSROOT_PREFIX/usr/lib
    cp libnewt.a $SYSROOT_PREFIX/usr/lib

  mkdir -p $SYSROOT_PREFIX/usr/lib/pkgconfig
    cp libnewt.pc $SYSROOT_PREFIX/usr/lib/pkgconfig

  mkdir -p $SYSROOT_PREFIX/usr/include
    cp newt.h $SYSROOT_PREFIX/usr/include

  mkdir -p $INSTALL/usr/bin
    cp whiptail $INSTALL/usr/bin
}
