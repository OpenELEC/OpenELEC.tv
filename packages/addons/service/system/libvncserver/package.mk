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

PKG_NAME="libvncserver"
PKG_VERSION="LibVNCServer-0.9.10"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="http://libvnc.github.io"
PKG_URL="https://www.dropbox.com/s/kit8fmaehl8ssn7/$PKG_NAME-$PKG_VERSION.tar.gz"
#PKG_URL="https://github.com/LibVNC/$PKG_NAME/archive/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain libpng libjpeg-turbo zlib libressl"
PKG_PRIORITY="optional"
PKG_SECTION="service/system"
PKG_SHORTDESC="libvncserver"
PKG_LONGDESC="libvncserver: A library for easy implementation of a VNC server."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-shared \
                           --enable-static \
                           --with-gnu-ld \
                           --without-filetransfer \
                           --with-sysroot=$SYSROOT_PREFIX \
                           --with-jpeg \
                           --with-png"

PKG_MAKE_OPTS_TARGET="-C libvncserver"
PKG_MAKEINSTALL_OPTS_TARGET="-C libvncserver"
