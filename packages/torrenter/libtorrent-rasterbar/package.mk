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

PKG_NAME="libtorrent-rasterbar"
PKG_VERSION="1.0.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="LGPL"
PKG_SITE="http://www.rasterbar.com/"
PKG_URL="http://droidboxcloud.co.uk/sources/$PKG_NAME-$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python boost"
PKG_PRIORITY="optional"
PKG_SECTION="torrenter"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

configure_target() {
  cd $ROOT/$PKG_BUILD

  export PYTHON_VERSION="2.7"
  export PYTHON_CPPFLAGS="-I$SYSROOT_PREFIX/usr/include/python$PYTHON_VERSION"
  export PYTHON_LDFLAGS="-L$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION -lpython$PYTHON_VERSION"
  export PYTHON_SITE_PKG="$SYSROOT_PREFIX/usr/lib/python$PYTHON_VERSION/site-packages"

  ./configure --host=$TARGET_NAME \
              --build=$HOST_NAME \
              --with-boost-libdir=$SYSROOT_PREFIX/usr/lib \
              --with-boost-python=$SYSROOT_PREFIX/usr/lib \
              --with-openssl=$SYSROOT_PREFIX/usr \
              --prefix=/usr \
              --disable-debug \
              --enable-python-binding
}

post_makeinstall_target() {
  rm -f $INSTALL/usr/lib/libtorrent-rasterbar.a
  rm -f $INSTALL/usr/lib/libtorrent-rasterbar.la
  rm -f $INSTALL/usr/lib/pkgconfig/libtorrent-rasterbar.pc
  rm -fr $INSTALL/usr/include/libtorrent
}
