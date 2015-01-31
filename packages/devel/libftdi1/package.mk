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

PKG_NAME="libftdi1"
PKG_VERSION="1.1"
PKG_REV=1""
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.intra2net.com/en/developer/libftdi/"
PKG_URL="http://www.intra2net.com/en/developer/libftdi/download/${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain libusb"
PKG_PRIORITY="optional"
PKG_SECTION="driver"
PKG_SHORTDESC="libFTDI is an open source library to talk to FTDI chips"
PKG_LONGDESC="libFTDI is an open source library to talk to FTDI chips"

PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

#PKG_CONFIGURE_OPTS_TARGET="ac_cv_path_HAVELIBUSB=$ROOT/$TOOLCHAIN/bin/libusb-config \
#                           LIBS=-lusb \
#                           --disable-shared \
#                           --enable-static

configure_target() {
  cmake -DCMAKE_TOOLCHAIN_FILE=$CMAKE_CONF \
        -DCMAKE_INSTALL_PREFIX=/usr \
	-DDOCUMENTATION=FALSE \
	-DEXAMPLES=FALSE \
	-DFTDIPP=FALSE \
	-DPYTHON_BINDINGS=FALSE \
        ..
}

pre_configure_target() {
  CFLAGS="$CFLAGS -fPIC -DPIC"
}

#post_makeinstall_target() {
#  rm -rf $INSTALL/usr/bin
#}
